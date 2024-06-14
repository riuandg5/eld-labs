`timescale 1ns / 1ps

module counter_3bit_tb;
    reg clk, reset;
    wire [2:0] count;

    counter_3bit c3b1 (.clk(clk), .reset(reset), .count(count));

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 0;

        reset = 1;
        #10 reset = 0;
        #50 reset = 1;
        #10 reset = 0;
    end
endmodule
