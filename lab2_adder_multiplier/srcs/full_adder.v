`timescale 1ns / 1ps

module full_adder(
    input a,
    input b,
    input cin,
    output s,
    output cout
    );

    wire s1, s2, cout1, cout2;

    half_adder ha1 (.a(a), .b(b), .s(s1), .cout(cout1));
    half_adder ha2 (.a(cin), .b(s1), .s(s2), .cout(cout2));

    assign s = s2;
    assign cout = cout1 | cout2;
endmodule
