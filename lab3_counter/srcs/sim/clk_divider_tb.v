`timescale 1ns / 1ps

module clk_divider_tb;
    reg clk_in;
    wire clk_out;

    clk_divider #(.div_value(2)) cd1 (.clk_in(clk_in), .clk_out(clk_out));

    always begin
        #125 clk_in = ~clk_in;
    end

    initial begin
        clk_in = 0;
    end
endmodule
