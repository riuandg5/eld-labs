`timescale 1ns / 1ps

module top_FFT_tb;
    reg aclk;
    reg aresetn;

    reg [7:0] in_config_data;
    reg in_config_valid;
    wire in_config_ready;

    reg [31:0] in_data_im;
    reg [31:0] in_data_re;
    reg in_valid;
    wire in_ready;
    reg in_last;

    wire [31:0] out_data_im;
    wire [31:0] out_data_re;
    wire out_valid;
    reg out_ready;
    wire out_last;

    reg [31:0] input_signal [15:0];
    integer i = 0, j = 0;

    top_FFT tfft1 (
        .aclk(aclk),
        .aresetn(aresetn),

        .in_config_data(in_config_data),
        .in_config_valid(in_config_valid),
        .in_config_ready(in_config_ready),

        .in_data_im(in_data_im),
        .in_data_re(in_data_re),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_last(in_last),

        .out_data_im(out_data_im),
        .out_data_re(out_data_re),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_last(out_last)
    );

    always #5 aclk = ~aclk;

    initial begin
        aclk = 0;
        aresetn = 0;

        in_config_data = 8'd0;
        in_config_valid = 0;

        in_data_im = 32'd0;
        in_data_re = 32'd0;
        in_valid = 0;
        in_last = 0;

        out_ready = 1;

        for (i = 15; i >= 0; i = i - 1) begin
            input_signal[i] = 32'd0;
        end
    end

    initial begin
        #70;
        aresetn = 1;

        input_signal[0] = 32'b00100101100011010011000100110010;
        input_signal[1] = 32'b00111111001111100011111010111101;
        input_signal[2] = 32'b00111111011111101001100011111101;
        input_signal[3] = 32'b00111111000101100111100100011000;
        input_signal[4] = 32'b10111110010101001110011011001101;
        input_signal[5] = 32'b10111111010111011011001111010111;
        input_signal[6] = 32'b10111111011100110111100001110001;
        input_signal[7] = 32'b10111110110100000011111111001001;
        input_signal[8] = 32'b00111110110100000011111111001001;
        input_signal[9] = 32'b00111111011100110111100001110001;
        input_signal[10] = 32'b00111111010111011011001111010111;
        input_signal[11] = 32'b00111110010101001110011011001101;
        input_signal[12] = 32'b10111111000101100111100100011000;
        input_signal[13] = 32'b10111111011111101001100011111101;
        input_signal[14] = 32'b10111111001111100011111010111101;
        input_signal[15] = 32'b10100101100011010011000100110010;
    end

    initial begin
        #100;
        in_config_data = 1;
        #5 in_config_valid = 1;

        while (in_config_ready == 0) begin
            in_config_valid = 1;
        end

        #5 in_config_valid = 0;
    end

    initial begin
        #100;
        for (j = 15; j >= 0; j = j - 1) begin
            #10;
            if (j == 0) begin
                in_last = 1;
            end

            in_data_re = input_signal[j];
            in_valid = 1;

            while (in_ready == 0) begin
                in_valid = 1;
            end
        end

        #10;
        in_valid = 0;
        in_last = 0;
    end

    initial begin
        #100;
        wait(out_valid == 1);
        #300 out_ready = 0;
    end
endmodule
