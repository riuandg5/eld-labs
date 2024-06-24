`timescale 1ns / 1ps

module top_BROM (
    input clk,
    output reg [3:0] max_value = 0
);

    reg [3:0] brom_addr = 0;
    wire [3:0] brom_value;

    blk_mem_gen_0 brom1 (
        .clka(clk),
        .addra(brom_addr),
        .douta(brom_value)
    );

    always @(posedge clk) begin
        if (brom_addr < 4'd9) brom_addr <= brom_addr + 1;
    end

    always @(brom_value) begin
        max_value = brom_value > max_value ? brom_value : max_value;
    end

endmodule
