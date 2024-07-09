#include "xil_printf.h"
#include "xil_cache.h"
#include "platform.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "sleep.h"

XAxiDma AxiDma;

int init_dma() {
	u32 device_id = XPAR_AXI_DMA_0_DEVICE_ID;

	XAxiDma_Config *DmaConfig = XAxiDma_LookupConfig(device_id);
	if (!DmaConfig) {
		xil_printf("No config found.\n");
		return XST_FAILURE;
	}

	int config_status = XAxiDma_CfgInitialize(&AxiDma, DmaConfig);
	if (config_status != XST_SUCCESS) {
		xil_printf("Init failed. Config status: %d.\n", config_status);
		return XST_FAILURE;
	}

	if (XAxiDma_HasSg(&AxiDma)) {
		xil_printf("Configured in SG mode.\n");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int main() {
	u32 init_status = init_dma();
	if (init_status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	int FIFO_DEPTH = 128;
	int tx_fifo[FIFO_DEPTH];
	int rx_fifo[FIFO_DEPTH];
	u32 fifo_size = sizeof(int) * FIFO_DEPTH;

	for (int i = 0; i < FIFO_DEPTH; i++) {
		tx_fifo[i] = 1 * i + 1;
	}

	Xil_DCacheFlushRange((UINTPTR) tx_fifo, fifo_size);
	Xil_DCacheFlushRange((UINTPTR) rx_fifo, fifo_size);

	xil_printf("DMA status before transfer:\n"
			"DMA to FIFO: %u\nFIFO to DMA: %u\n",
			XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));

	u32 transfer_status;

	transfer_status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR) tx_fifo,
			fifo_size, XAXIDMA_DMA_TO_DEVICE);
	if (transfer_status != XST_SUCCESS) {
		xil_printf("Transferring data from DDR to FIFO via DMA failed.\n");
	}

	xil_printf("DMA status between transfer:\n"
			"DMA to FIFO: %u\nFIFO to DMA: %u\n",
			XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));

	transfer_status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR) rx_fifo,
			fifo_size, XAXIDMA_DEVICE_TO_DMA);
	if (transfer_status != XST_SUCCESS) {
		xil_printf("Transferring data from FIFO to DDR via DMA failed.\n");
	}

	xil_printf("DMA status after transfer:\n"
			"DMA to FIFO: %u\nFIFO to DMA: %u\n",
			XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));

	u32 dma2dev_busy = XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA);
	u32 dev2dma_busy = XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE);

	while (dma2dev_busy || dev2dma_busy) {
		dma2dev_busy = XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA);
		dev2dma_busy = XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE);
		xil_printf("DMA status while waiting:\n"
				"DMA to FIFO: %u\nFIFO to DMA: %u\n", dma2dev_busy,
				dev2dma_busy);
		usleep(1U);
	}

	xil_printf("DMA status after waiting:\n"
			"DMA to FIFO: %u\nFIFO to DMA: %u\n",
			XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));

	Xil_DCacheInvalidateRange((UINTPTR) rx_fifo, fifo_size);

	int data_mismatch = 0;

	int i = 0;
	for (i = 0; i < FIFO_DEPTH; i++) {
		if (tx_fifo[i] != rx_fifo[i]) {
			data_mismatch = 1;
			break;
		}
	}

	if (data_mismatch == 1) {
		xil_printf("Data mismatch found at index: %d. Tx data: %d. Rx Data: %d",
				i, tx_fifo[i], rx_fifo[i]);
	}

	return XST_SUCCESS;
}
