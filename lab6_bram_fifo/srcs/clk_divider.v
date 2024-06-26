`timescale 1ns / 1ps

module clk_divider # (
    parameter integer DIV_VALUE = 5
) (
    input clk_in,
    output reg clk_out = 0
);

    reg [31:0] count = 0;

    always @(posedge clk_in) begin
        if (count == (DIV_VALUE - 1)) begin
            count <= 0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1;
        end
    end
endmodule
