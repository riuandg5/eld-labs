`timescale 1ns / 1ps

module top_seq_detector (
    input clk_100M,
    input reset,
    input push_0,
    input push_1,
    output [2:0] curr_state,
    output seq_detected
);

    wire clk_5M, clk_200H;
    wire btn_pushed;

    clk_wiz_0 cw01 (
        .clk_in1(clk_100M),
        .clk_out1(clk_5M)
    );

    clk_divider # (
        .div_value(12500)
    ) cd1 (
        .clk_in(clk_5M),
        .clk_out(clk_200H)
    );

    btn_pushed bp1 (
        .clk_200H(clk_200H),
        .push_0(push_0),
        .push_1(push_1),
        .btn_pushed(btn_pushed)
    );

    fsm_11011 fsm1 (
        .clk(btn_pushed),
        .reset(reset),
        .curr_input(push_1),
        .curr_state(curr_state),
        .seq_detected(seq_detected)
    );
endmodule
