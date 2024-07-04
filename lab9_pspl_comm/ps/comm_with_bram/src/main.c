#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xil_cache.h"
#include "xil_printf.h"


int main()
{
    init_platform();

    // input data array
    int data_in[] = {4, 9, 16, 8, 36, 49, 64, 81, 100, 121};
    // length of input data array
    // (4*10)/4, as int is of 4 Bytes
    int total_data = sizeof(data_in)/sizeof(data_in[0]);

    // base address of bram
    int base_addr = XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;
    // size of each address in bits
    int addr_size = 8; // 1 Byte address

    printf("Start writing data to bram\n\r");
    // write input data to bram
    for(int i = 0; i < total_data; i++) {
    	// calculate current address as base address + offset * address size
    	int curr_addr = base_addr + i * addr_size;

    	// write 4*8 bits input data at current address
    	Xil_Out32(curr_addr, data_in[i]);
    	printf("index = %d, address = %d, data = %d\n", i, curr_addr, data_in[i]);
    }
    printf("\nDone writing data to bram\n\r");

    printf("Start reading data from bram\n\r");
    // read data from bram
	for(int i = 0; i < total_data; i++) {
		// calculate current address as base address + offset * address size
		int curr_addr = base_addr + i * addr_size;

		// read 4*8 bits data at current address
		int data_out = Xil_In32(curr_addr);
		printf("index = %d, address = %d, data = %d\n", i, curr_addr, data_out);
	}
	printf("\nDone reading data from bram\n\r");

    cleanup_platform();
    return 0;
}
