`timescale 1ns / 1ps

module top_FIFO (
    input clk_100M,
    input reset,
    input [3:0] din,
    input write,
    input read,
    output [3:0] dout,
    output full,
    output almost_full,
    output empty,
    output almost_empty,
    output [3:0] data_count
);

    wire clk_5M, clk_200H;
    wire btn_pushed;

    clk_wiz_0 cw01 (
        .clk_in1(clk_100M),
        .clk_out1(clk_5M)
    );

    clk_divider # (
        .DIV_VALUE(12500)
    ) cd1 (
        .clk_in(clk_5M),
        .clk_out(clk_200H)
    );

    btn_pushed bp1 (
        .clk_200H(clk_200H),
        .push_0(read),
        .push_1(write),
        .btn_pushed(btn_pushed)
    );

    fifo_generator_0 fifo01 (
        .clk(btn_pushed),
        .srst(reset),
        .din(din),
        .wr_en(write),
        .rd_en(read),
        .dout(dout),
        .full(full),
        .almost_full(almost_full),
        .empty(empty),
        .almost_empty(almost_empty),
        .data_count(data_count)
    );

    ila_0 ila01 (
        .clk(clk_100M),
        .probe0(reset),
        .probe1(din),
        .probe2(write),
        .probe3(read),
        .probe4(dout),
        .probe5(full),
        .probe6(almost_full),
        .probe7(empty),
        .probe8(almost_empty),
        .probe9(data_count)
    );
endmodule
