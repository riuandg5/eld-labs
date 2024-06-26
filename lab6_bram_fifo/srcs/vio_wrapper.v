`timescale 1ns / 1ps

module vio_wrapper (
    input sys_clk
);

    wire reset, write, read, full, almost_full, empty, almost_empty;
    wire [3:0] din, dout, data_count;

    vio_0 v01 (
        .clk(sys_clk),
        .probe_in0(dout),
        .probe_in1(full),
        .probe_in2(almost_full),
        .probe_in3(empty),
        .probe_in4(almost_empty),
        .probe_in5(data_count),
        .probe_out0(reset),
        .probe_out1(din),
        .probe_out2(write),
        .probe_out3(read)
    );

    top_FIFO tfifo1 (
        .clk_100M(sys_clk),
        .reset(reset),
        .din(din),
        .write(write),
        .read(read),
        .dout(dout),
        .full(full),
        .almost_full(almost_full),
        .empty(empty),
        .almost_empty(almost_empty),
        .data_count(data_count)
    );
endmodule
