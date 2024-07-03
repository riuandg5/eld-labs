#include <complex.h>
#include <stdio.h>
#include <stdlib.h>

#define N 8

const int rev8[N] = {0, 4, 2, 6, 1, 5, 3, 7};

const float complex W[N / 2] = {1 - 0 * I, 0.7071067811865476 - 0.7071067811865475 * I, 0 - 1 * I, -0.7071067811865475 - 0.7071067811865476 * I};

void bitreverse(float complex dataIn[N], float complex dataOut[N])
{
bit_reversal:
	for (int i = 0; i < N; i++)
	{
		dataOut[i] = dataIn[rev8[i]];
	}
}

void FFT_stages(float complex FFT_input[N], float complex FFT_output[N])
{
	float complex temp1[N], temp2[N];

stage1:
	for (int i = 0; i < N; i = i + 2)
	{
		temp1[i] = FFT_input[i] + FFT_input[i + 1];
		temp1[i + 1] = FFT_input[i] - FFT_input[i + 1];
	}

stage2:
	for (int i = 0; i < N; i = i + 4)
	{
		for (int j = 0; j < 2; ++j)
		{
			temp2[i + j] = temp1[i + j] + W[2 * j] * temp1[i + j + 2];
			temp2[i + j + 2] = temp1[i + j] - W[2 * j] * temp1[i + j + 2];
		}
	}

stage3:
	for (int i = 0; i < N / 2; i++)
	{
		FFT_output[i] = temp2[i] + W[i] * temp2[i + 4];
		FFT_output[i + 4] = temp2[i] - W[i] * temp2[i + 4];
	}
}

int main()
{
	const float complex FFT_input[N] = {11 + 23 * I, 32 + 10 * I, 91 + 94 * I, 15 + 69 * I, 47 + 96 * I, 44 + 12 * I, 96 + 17 * I, 49 + 58 * I};

	float complex FFT_output[N];

	float complex FFT_rev[N];

	bitreverse(FFT_input, FFT_rev);
	FFT_stages(FFT_rev, FFT_output);

	printf("\nPrinting FFT input\r\n");
	for (int i = 0; i < N; i++)
	{
		printf("%f %f\n", creal(FFT_input[i]), cimag(FFT_input[i]));
	}

	printf("\nPrinting FFT output\r\n");
	for (int i = 0; i < N; i++)
	{
		printf("%f %f\n", creal(FFT_output[i]), cimag(FFT_output[i]));
	}
}
