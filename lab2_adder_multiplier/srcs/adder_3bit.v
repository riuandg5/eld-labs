`timescale 1ns / 1ps

module adder_3bit(
    input [2:0] a,
    input [2:0] b,
    output [3:0] s
    );

    wire cout0, cout1;

    full_adder fa1 (.a(a[0]), .b(b[0]), .cin(1'b0), .s(s[0]), .cout(cout0));
    full_adder fa2 (.a(a[1]), .b(b[1]), .cin(cout0), .s(s[1]), .cout(cout1));
    full_adder fa3 (.a(a[2]), .b(b[2]), .cin(cout1), .s(s[2]), .cout(s[3]));
endmodule
