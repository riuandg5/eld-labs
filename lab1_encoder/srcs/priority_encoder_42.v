`timescale 1ns / 1ps

module priority_encoder_42(
    input [3:0] enc_in,
    output [1:0] enc_out,
    output valid_out
    );

    assign valid_out = |enc_in;
    assign enc_out[0] = (enc_in[1] & ~enc_in[2]) | enc_in[3];
    assign enc_out[1] = enc_in[2] | enc_in[3];
endmodule
