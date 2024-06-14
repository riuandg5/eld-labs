`timescale 1ns / 1ps

module top_counter(
    input clk_100M,
    input reset,
    output [2:0] count
    );

    wire clk_5M, clk_1H;

    clk_wiz_0 cw01 (.clk_in1(clk_100M), .clk_out1(clk_5M));

    clk_divider #(.div_value(2500000)) cd1 (.clk_in(clk_5M), .clk_out(clk_1H));

    counter_3bit c3b1 (.clk(clk_1H), .reset(reset), .count(count));

    ila_0 ila01 (.clk(clk_100M), .probe0(clk_1H), .probe1(reset), .probe2(count));
endmodule
