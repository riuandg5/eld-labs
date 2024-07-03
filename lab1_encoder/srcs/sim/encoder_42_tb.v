`timescale 1ns / 1ps

module encoder_42_tb;
    reg [3:0] enc_in;
    wire [1:0] enc_out;
    wire [1:0] penc_out;
    wire penc_valid_out;
    encoder_42 enc_inst (.enc_in(enc_in), .enc_out(enc_out));
    priority_encoder_42 penc_inst (.enc_in(enc_in), .enc_out(penc_out), .valid_out(penc_valid_out));

    initial begin
        enc_in = 4'b0001;
        #5 enc_in = 4'b0010;
        #5 enc_in = 4'b0100;
        #5 enc_in = 4'b1000;
        #5 enc_in = 4'b0000;
        #5 enc_in = 4'b0110;
    end
endmodule
