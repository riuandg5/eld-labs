`timescale 1ns / 1ps

module btn_pushed (
    input clk_200H,
    input push_0,
    input push_1,
    output reg btn_pushed = 0
);

    always @(posedge clk_200H) begin
        btn_pushed <= push_0 | push_1;
    end

endmodule
