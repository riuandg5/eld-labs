`timescale 1ns / 1ps

module top_FFT (
    input aclk,
    input aresetn,

    input [7:0] in_config_data,
    input in_config_valid,
    output in_config_ready,

    input [31:0] in_data_im,
    input [31:0] in_data_re,
    input in_valid,
    output in_ready,
    input in_last,

    output [31:0] out_data_im,
    output [31:0] out_data_re,
    output out_valid,
    input out_ready,
    output out_last
);

    wire event_frame_started, event_tlast_unexpected, event_tlast_missing,
        event_status_channel_halt, event_data_in_channel_halt, event_data_out_channel_halt;

    xfft_0 fft16_01 (
        .aclk(aclk),
        .aresetn(aresetn),

        .s_axis_config_tdata(in_config_data),
        .s_axis_config_tvalid(in_config_valid),
        .s_axis_config_tready(in_config_ready),

        .s_axis_data_tdata({in_data_im, in_data_re}),
        .s_axis_data_tvalid(in_valid),
        .s_axis_data_tready(in_ready),
        .s_axis_data_tlast(in_last),

        .m_axis_data_tdata({out_data_im, out_data_re}),
        .m_axis_data_tvalid(out_valid),
        .m_axis_data_tready(out_ready),
        .m_axis_data_tlast(out_last),

        .event_frame_started(event_frame_started),
        .event_tlast_unexpected(event_tlast_unexpected),
        .event_tlast_missing(event_tlast_missing),
        .event_status_channel_halt(event_status_channel_halt),
        .event_data_in_channel_halt(event_data_in_channel_halt),
        .event_data_out_channel_halt(event_data_out_channel_halt)
    );
endmodule
