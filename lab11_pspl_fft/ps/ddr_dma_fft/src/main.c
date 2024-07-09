#include <stdio.h>
#include <complex.h>
#include "xil_printf.h"
#include "xil_cache.h"
#include "platform.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "sleep.h"
#include "xtime_l.h"

#define N 8

const int rev8[N] = { 0, 4, 2, 6, 1, 5, 3, 7 };

const float complex W[N / 2] = { 1 - 0 * I, 0.7071067811865476
		- 0.7071067811865475 * I, 0 - 1 * I, -0.7071067811865475
		- 0.7071067811865476 * I };

void bitreverse(float complex dataIn[N], float complex dataOut[N]) {
	bit_reversal: for (int i = 0; i < N; i++) {
		dataOut[i] = dataIn[rev8[i]];
	}
}

void FFT_stages(float complex FFT_input[N], float complex FFT_output[N]) {
	float complex temp1[N], temp2[N];

	stage1: for (int i = 0; i < N; i = i + 2) {
		temp1[i] = FFT_input[i] + FFT_input[i + 1];
		temp1[i + 1] = FFT_input[i] - FFT_input[i + 1];
	}

	stage2: for (int i = 0; i < N; i = i + 4) {
		for (int j = 0; j < 2; ++j) {
			temp2[i + j] = temp1[i + j] + W[2 * j] * temp1[i + j + 2];
			temp2[i + j + 2] = temp1[i + j] - W[2 * j] * temp1[i + j + 2];
		}
	}

	stage3: for (int i = 0; i < N / 2; i++) {
		FFT_output[i] = temp2[i] + W[i] * temp2[i + 4];
		FFT_output[i + 4] = temp2[i] - W[i] * temp2[i + 4];
	}
}

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
	XTime tp_start, tp_end;
	XTime tf_start, tf_end;

	const float complex FFT_input[N] = { 11 + 23 * I, 32 + 10 * I, 91 + 94 * I,
			15 + 69 * I, 47 + 96 * I, 44 + 12 * I, 96 + 17 * I, 49 + 58 * I };

	float complex FFT_output_PS[N];

	float complex FFT_rev[N];

	XTime_GetTime(&tp_start);
	bitreverse(FFT_input, FFT_rev);
	FFT_stages(FFT_rev, FFT_output_PS);
	XTime_GetTime(&tp_end);

	// printf("\nPrinting FFT input\r\n");
	// for (int i = 0; i < N; i++)
	// {
	// 	printf("%f %f\n", creal(FFT_input[i]), cimag(FFT_input[i]));
	// }

	// printf("\nPrinting FFT output\r\n");
	// for (int i = 0; i < N; i++)
	// {
	// 	printf("%f %f\n", creal(FFT_output[i]), cimag(FFT_output[i]));
	// }

	u32 init_status = init_dma();
	if (init_status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// int FIFO_DEPTH = 128;
	// int tx_fifo[FIFO_DEPTH];
	float complex rx_fifo[N];
	u32 fifo_size = sizeof(float complex) * N;

	// for (int i = 0; i < FIFO_DEPTH; i++) {
	// 	tx_fifo[i] = 1 * i + 1;
	// }

	Xil_DCacheFlushRange((UINTPTR) FFT_input, fifo_size);
	Xil_DCacheFlushRange((UINTPTR) rx_fifo, fifo_size);

	xil_printf("DMA status before transfer:\n"
			"DMA to FIFO: %u\nFIFO to DMA: %u\n",
			XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA),
			XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));

	u32 transfer_status;

	XTime_GetTime(&tf_start);

	transfer_status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR) FFT_input,
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

	XTime_GetTime(&tf_end);

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
	for (i = 0; i < N; i++) {
		printf("PS output: %f + I%f, PL output: %f + I%f\n",
				crealf(FFT_output_PS[i]), cimagf(FFT_output_PS[i]),
				crealf(rx_fifo[i]), cimagf(rx_fifo[i]));

		float diff1 = crealf(FFT_output_PS[i]) - crealf(rx_fifo[i]);
		float diff2 = cimagf(FFT_output_PS[i]) - cimagf(rx_fifo[i]);

		if (diff1 >= 0.0001 || diff2 >= 0.0001) {
			data_mismatch = 1;
			break;
		}

		// if (tx_fifo[i] != rx_fifo[i]) {
		// 	data_mismatch = 1;
		// 	break;
		// }
	}

	if (data_mismatch == 1) {
		printf(
				"Data mismatch found at index: %d. Tx data: %f + I%f. Rx Data: %f + I%f",
				i, crealf(FFT_output_PS[i]), cimagf(FFT_output_PS[i]),
				crealf(rx_fifo[i]), cimagf(rx_fifo[i]));
	}

	float tp = (float) 1.0 * (tp_end - tp_start)
			/ (COUNTS_PER_SECOND / 1000000);
	float tf = (float) 1.0 * (tf_end - tf_start)
			/ (COUNTS_PER_SECOND / 1000000);

	printf("Time taken by PS: %f\n", tp);
	printf("Time taken by PL: %f\n", tf);

	return XST_SUCCESS;
}
