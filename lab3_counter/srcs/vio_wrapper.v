`timescale 1ns / 1ps

module vio_wrapper(
    input sys_clk
    );
    
    wire [2:0] count;
    wire reset;
    
    vio_0 v01 (
        .clk(sys_clk),
        .probe_in0(count),
        .probe_out0(reset)
    );
    
    top_counter tc1 (.clk_100M(sys_clk), .reset(reset), .count(count));
endmodule
