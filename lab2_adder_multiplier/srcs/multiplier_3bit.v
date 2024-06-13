`timescale 1ns / 1ps

module multiplier_3bit(
    input [2:0] a,
    input [2:0] b,
    output [5:0] m
    );
    
    wire [2:0] p0, p1, p2;
    assign p0 = b[0] ? a : 3'b000;
    assign p1 = b[1] ? a : 3'b000;
    assign p2 = b[2] ? a : 3'b000;
    assign m[0] = p0[0];
    
    wire [3:0] s0;
    adder_3bit a3b1 (.a(p0 >> 1), .b(p1), .s(s0));
    assign m[1] = s0[0];
    
    wire [3:0] s1;
    adder_3bit a3b2 (.a(s0 >> 1), .b(p2), .s(s1));
    assign m[5:2] = s1;
endmodule
