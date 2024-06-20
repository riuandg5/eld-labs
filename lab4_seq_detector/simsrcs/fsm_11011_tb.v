`timescale 1ns / 1ps

module fsm_11011_tb;
    reg clk, reset, curr_input;
    wire [2:0] curr_state;
    wire seq_detected;

    fsm_11011 fsm1 (
        .clk(clk),
        .reset(reset),
        .curr_input(curr_input),
        .curr_state(curr_state),
        .seq_detected(seq_detected)
    );

    initial begin
        clk = 0;
        reset = 1;
        curr_input = 0;
    end

    always #5 clk = ~clk;

    initial begin
        #10 reset = 0;

        @(negedge clk) curr_input = 1;
        @(negedge clk) curr_input = 1;
        @(negedge clk) curr_input = 0;
        @(negedge clk) curr_input = 1;
        @(negedge clk) curr_input = 1;
        @(negedge clk) curr_input = 0;
        @(negedge clk) curr_input = 1;
        @(negedge clk) curr_input = 1;
    end
    
endmodule