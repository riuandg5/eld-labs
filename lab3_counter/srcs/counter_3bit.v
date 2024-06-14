`timescale 1ns / 1ps

module counter_3bit(
    input clk,
    input reset,
    output reg [2:0] count
    );
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 3'b0;
        end else begin
            count <= count + 1;
        end
    end
endmodule
