#include "platform.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_io.h"

int main()
{
    // Initialize the platform (sets up the hardware and necessary libraries)
    init_platform();

    // Define the input data array with hardcoded entries
    u32 data_in[] = {4, 9, 16, 8, 36, 49, 64, 81, 100, 121};
    // Calculate the number of elements in the input data array
    u32 data_size = sizeof(u32);
    u32 total_data = sizeof(data_in) / data_size;

    // Store the base address of BRAM
    UINTPTR bram_base_addr = XPAR_BRAM_0_BASEADDR;
    // Define address size >= data size
    u32 addr_size = data_size;

    // Variable to store calculated current address
    UINTPTR curr_addr;

    // Begin the process of writing data to BRAM
    xil_printf("Start writing data to BRAM\n\r");
    for (u32 i = 0; i < total_data; i++) {
        // Calculate the current address as base address + offset
        curr_addr = bram_base_addr + i * addr_size;

        // Write a 4-byte (32-bit) integer from the data_in array to the calculated address in BRAM
        Xil_Out32(curr_addr, data_in[i]);
        xil_printf("index = %u, address = 0x%08X, data = %u\n", i, curr_addr, data_in[i]);
    }
    xil_printf("\nDone writing data to BRAM\n\r");

    // Variable to store data read
    u32 data_out;

    // Begin the process of reading data back from BRAM
    xil_printf("Start reading data from BRAM\n\r");
    for (u32 i = 0; i < total_data; i++) {
        // Calculate the current address as base address + offset
        curr_addr = bram_base_addr + i * addr_size;

        // Read a 4-byte (32-bit) integer from the calculated address in BRAM
        data_out = Xil_In32(curr_addr);
        xil_printf("index = %u, address = 0x%08X, data = %u\n", i, curr_addr, data_out);
    }
    xil_printf("\nDone reading data from BRAM\n\r");

    // Cleanup the platform (frees up resources used by the hardware and libraries)
    cleanup_platform();

    return 0;
}
