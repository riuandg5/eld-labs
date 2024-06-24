`timescale 1ns / 1ps

module top_BROM_tb;
    reg clk = 0;
    wire [3:0] max_value;

    top_BROM tbrom1 (
        .clk(clk),
        .max_value(max_value)
    );

    always #5 clk = ~clk;
endmodule
