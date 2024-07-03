`timescale 1ns / 1ps

module multiplier_3bit_tb;
    reg [2:0] a, b;
    wire [5:0] m;

    multiplier_3bit m3b1 (.a(a), .b(b), .m(m));

    initial begin
        a = 3'b000; b = 3'b000;
        #5 a = 3'b111; b = 3'b111;
        #5 a = 3'd3; b = 3'd4;
    end
endmodule
