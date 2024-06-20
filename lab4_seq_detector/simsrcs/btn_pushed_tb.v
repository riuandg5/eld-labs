`timescale 1ns / 1ps

module btn_pushed_tb;
    reg clk, push_0, push_1;
    wire btn_pushed;

    btn_pushed bp1 (
        .clk_200H(clk),
        .push_0(push_0),
        .push_1(push_1),
        .btn_pushed(btn_pushed)
    );

    initial begin
        clk = 0;
        push_0 = 0; push_1 = 0;

        #5 push_0 = 0; push_1 = 1;
        #40 push_0 = 0; push_1 = 0;
        #40 push_0 = 1; push_1 = 0;
        #40 push_0 = 0; push_1 = 0;
    end

    always #10 clk = ~clk;    
endmodule