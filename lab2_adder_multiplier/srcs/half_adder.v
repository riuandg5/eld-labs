`timescale 1ns / 1ps

module half_adder(
    input a,
    input b,
    output s,
    output cout
    );

    assign s = a ^ b;
    assign cout = a & b;
endmodule
