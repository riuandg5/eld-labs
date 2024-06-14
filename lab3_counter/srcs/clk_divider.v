`timescale 1ns / 1ps

module clk_divider #(parameter div_value = 5) (
    input clk_in,
    output reg clk_out = 0
    );

    reg [31:0] count = 0;
    
    always @(posedge clk_in) begin
        if (count == (div_value - 1)) begin
            count <= 3'b000;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1;
        end
    end
endmodule
