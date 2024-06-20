`timescale 1ns / 1ps

module fsm_11011 (
    input clk,
    input reset,
    input curr_input,
    output reg [2:0] curr_state,
    output reg seq_detected = 0
);

    reg [2:0] next_state;
    parameter IDLE = 0, S1 = 1, S11 = 2, S110 = 3, S1101 = 4;

    always @(posedge clk, posedge reset) begin
        if (reset)
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end

    always @(curr_state, curr_input) begin
        case (curr_state)
            IDLE: begin
                // 1
                if (curr_input) next_state = S1;
                // 0
                else next_state = IDLE;
            end

            S1: begin
                // 11
                if (curr_input) next_state = S11;
                // 10
                else next_state = IDLE;
            end

            S11: begin
                // 111 (overlap)
                if (curr_input) next_state = S11;
                // 110
                else next_state = S110;
            end

            S110: begin
                // 1101
                if (curr_input) next_state = S1101;
                // 1100
                else next_state = IDLE;
            end

            S1101: begin
                // 11011 (overlap)
                if (curr_input) next_state = S11;
                // 11010
                else next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        seq_detected = (curr_state == S1101) && curr_input ? 1 : 0;
    end
endmodule
