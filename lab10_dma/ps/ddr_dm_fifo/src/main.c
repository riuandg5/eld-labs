#include "xil_printf.h"
#include "xil_cache.h"
#include "platform.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "sleep.h"

enum AppErrCode {
	SUCCESS,
	DEVICE_NOT_FOUND,
	DMA_CONFIG_INIT_FAILED,
	DMA_IN_SG_MODE,
	DMA_INIT_FAILED,
	DMA_TO_DEVICE_FAILED,
	DEVICE_TO_DMA_FAILED,
	DATA_MISMATCH,
	DATA_TRANSFER_FAILED
};

int init_axi_dma(XAxiDma *pAxiDma, int axiDmaId);
int transfer_via_axi_dma(XAxiDma *pAxiDma, int axiDmaId, int *txBuffer,
		int *rxBuffer, int bufferLength);

int main() {
	// initialize dma
	XAxiDma axiDma0;
	int axiDma0Id = XPAR_AXI_DMA_0_DEVICE_ID;
	if (init_axi_dma(&axiDma0, axiDma0Id) != SUCCESS) {
		xil_printf("[ERROR][DMA][ID:%d] Init failed.\n", axiDma0Id);
		return DMA_INIT_FAILED;
	}

	// prepare tx and rx buffers
	int bufferLength = 128;
	// buffers in cache
	int txBuffer[bufferLength];
	int rxBuffer[bufferLength];

	// populate tx buffer
	for (int i = 0; i < bufferLength; i++) {
		txBuffer[i] = 1 * i + 1;
	}

	// perform two way transfer of data
	if (transfer_via_axi_dma(&axiDma0, axiDma0Id, txBuffer, rxBuffer,
			bufferLength) != SUCCESS) {
		xil_printf("[ERROR][DMA][ID:%d] Data transfer failed.\n", axiDma0Id);
		return DATA_TRANSFER_FAILED;
	}

	return SUCCESS;
}

int init_axi_dma(XAxiDma *pAxiDma, int axiDmaId) {
	// get dma config
	XAxiDma_Config *pDmaConfig = XAxiDma_LookupConfig(axiDmaId);
	if (pDmaConfig == NULL) {
		xil_printf("[ERROR][DMA][ID:%d] Device not found.\n", axiDmaId);
		return DEVICE_NOT_FOUND;
	}

	// initialize dma config
	u32 configStatus = XAxiDma_CfgInitialize(pAxiDma, pDmaConfig);
	if (configStatus != XST_SUCCESS) {
		xil_printf("[ERROR][DMA][ID:%d] Config init failed with status: %u\n",
				axiDmaId, configStatus);
		return DMA_CONFIG_INIT_FAILED;
	}

	// check if it is in scatter gather mode
	u32 dmaInSgMode = XAxiDma_HasSg(pAxiDma);
	if (dmaInSgMode) {
		xil_printf("[ERROR][DMA][ID:%d] In SG Mode.\n", axiDmaId);
		return DMA_IN_SG_MODE;
	}

	return SUCCESS;
}

int transfer_via_axi_dma(XAxiDma *pAxiDma, int axiDmaId, int *txBuffer,
		int *rxBuffer, int bufferLength) {
	u32 bufferSize = sizeof(int) * bufferLength;

	// flush buffers data from cache to ddr
	Xil_DCacheFlushRange((INTPTR) txBuffer, bufferSize);
	Xil_DCacheFlushRange((INTPTR) rxBuffer, bufferSize);

	xil_printf("[INFO][DMA][ID:%d] Status before transfer: "
			"FIFO to DMA:%u DMA to FIFO:%u\n", axiDmaId,
			XAxiDma_Busy(pAxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(pAxiDma, XAXIDMA_DMA_TO_DEVICE));

	u32 transferSubmitStatus;

	// submit transfer request from device to dma
	transferSubmitStatus = XAxiDma_SimpleTransfer(pAxiDma, (UINTPTR) rxBuffer,
			bufferSize, XAXIDMA_DEVICE_TO_DMA);
	if (transferSubmitStatus != XST_SUCCESS) {
		xil_printf("[ERROR][DMA][ID:%d] Transfer submission from "
				"FIFO to DMA failed.\n", axiDmaId);
		return DEVICE_TO_DMA_FAILED;
	}

	xil_printf("[INFO][DMA][ID:%d] Status between transfer: "
			"FIFO to DMA:%u DMA to FIFO:%u\n", axiDmaId,
			XAxiDma_Busy(pAxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(pAxiDma, XAXIDMA_DMA_TO_DEVICE));

	// submit transfer status from dma to device
	transferSubmitStatus = XAxiDma_SimpleTransfer(pAxiDma, (UINTPTR) txBuffer,
			bufferSize, XAXIDMA_DMA_TO_DEVICE);
	if (transferSubmitStatus != XST_SUCCESS) {
		xil_printf("[ERROR][DMA][ID:%d] Transfer submission from "
				"DMA to FIFO failed.\n", axiDmaId);
		return DMA_TO_DEVICE_FAILED;
	}

	xil_printf("[INFO][DMA][ID:%d] Status after transfer: "
			"FIFO to DMA:%u DMA to FIFO:%u\n", axiDmaId,
			XAxiDma_Busy(pAxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(pAxiDma, XAXIDMA_DMA_TO_DEVICE));

	u32 devToDmaBusy = XAxiDma_Busy(pAxiDma, XAXIDMA_DEVICE_TO_DMA);
	u32 dmaToDevBusy = XAxiDma_Busy(pAxiDma, XAXIDMA_DMA_TO_DEVICE);

	// wait till transfer is happening
	while (dmaToDevBusy || devToDmaBusy) {
		devToDmaBusy = XAxiDma_Busy(pAxiDma, XAXIDMA_DEVICE_TO_DMA);
		dmaToDevBusy = XAxiDma_Busy(pAxiDma, XAXIDMA_DMA_TO_DEVICE);
		xil_printf("[INFO][DMA][ID:%d] Status while waiting: "
				"FIFO to DMA:%u DMA to FIFO:%u\n", axiDmaId, devToDmaBusy,
				dmaToDevBusy);
		usleep(1U);
	}

	xil_printf("[INFO][DMA][ID:%d] Status after waiting: "
			"FIFO to DMA:%u DMA to FIFO:%u\n", axiDmaId,
			XAxiDma_Busy(pAxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(pAxiDma, XAXIDMA_DMA_TO_DEVICE));

	// invalidate rx buffer data from cache
	Xil_DCacheInvalidateRange((INTPTR) rxBuffer, bufferSize);

	// check for first data mismatch
	int dataMismatch = 0;

	int i = 0;
	for (i = 0; i < bufferLength; i++) {
		if (txBuffer[i] != rxBuffer[i]) {
			dataMismatch = 1;
			break;
		}
	}

	if (dataMismatch == 1) {
		xil_printf("[ERROR][DMA][ID:%d] First data mismatch found at index:%d. "
				"Tx data:%d. Rx Data:%d", axiDmaId, i, txBuffer[i],
				rxBuffer[i]);
		return DATA_MISMATCH;
	}

	return SUCCESS;
}

