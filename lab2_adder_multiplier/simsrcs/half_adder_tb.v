`timescale 1ns / 1ps

module half_adder_tb;
    reg a, b;
    wire s, cout;

    half_adder ha1 (.a(a), .b(b), .s(s), .cout(cout));

    initial begin
        a = 1'b0; b = 1'b0;
        #5 a = 1'b0; b = 1'b1;
        #5 a = 1'b1; b = 1'b0;
        #5 a = 1'b1; b = 1'b1;
    end
endmodule
