`timescale 1ns / 1ps

module vio_wrapper (
    input sys_clk
);
    
    wire [2:0] curr_state;
    wire seq_detected;
    wire reset, push_0, push_1;
    
    vio_0 v01 (
        .clk(sys_clk),
        .probe_in0(curr_state),
        .probe_in1(seq_detected),
        .probe_out0(reset),
        .probe_out1(push_0),
        .probe_out2(push_1)
    );
    
    top_seq_detector tsd1 (
        .clk_100M(sys_clk),
        .reset(reset),
        .push_0(push_0),
        .push_1(push_1),
        .curr_state(curr_state),
        .seq_detected(seq_detected)
    );
endmodule
