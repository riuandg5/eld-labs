`timescale 1ns / 1ps

module gcd_tb;
    reg clk, reset, start;
    reg [3:0] a, b;
    wire [3:0] gcd;

    gcd g1 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .gcd(gcd)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; reset = 1; start = 0;
        a = 0;  b = 0;

        #5 reset = 0; start = 1;
        a = 3; b = 7;
        #500 reset = 1; start = 0;

        #5 reset = 0; start = 1;
        a = 8; b = 4;
        #500 reset = 1; start = 0;
    end
endmodule
