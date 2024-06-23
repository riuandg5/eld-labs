`timescale 1ns / 1ps

module gcd_controller (
    input clk,
    input reset,
    input start,
    input flag_eq,
    input flag_lt,
    output reg sel_a = 0,
    output reg sel_b = 0,
    output reg load_a = 0,
    output reg load_b = 0,
    output reg load_gcd = 0,
    output [5:0] debug
);

    parameter integer IDLE = 0, START = 1, TEST_EQ = 2, TEST_LT = 3, UPDATE_A = 4, UPDATE_B = 5,
        DONE = 6;
    reg [2:0] curr_state = 0, next_state;
    assign debug = {curr_state, next_state};

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            curr_state <= IDLE;
        end else begin
            curr_state <= next_state;
        end
    end

    always @(*) begin
        case (curr_state)
            IDLE: begin
                if (start) next_state = START;
                else next_state = IDLE;
            end
            START: next_state = TEST_EQ;
            TEST_EQ: begin
                if (flag_eq) next_state = DONE;
                else next_state = TEST_LT;
            end
            TEST_LT: begin
                if (flag_lt) next_state = UPDATE_B;
                else next_state = UPDATE_A;
            end
            UPDATE_A: next_state = TEST_EQ;
            UPDATE_B: next_state = TEST_EQ;
            DONE: begin
                if (reset) next_state = IDLE;
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        sel_a = 0; sel_b = 0;
        load_a = 0; load_b = 0;
        load_gcd = 0;
        case (curr_state)
            START: begin
                sel_a = 1; sel_b = 1;
                load_a = 1; load_b = 1;
            end
            UPDATE_A: load_a = 1;
            UPDATE_B: load_b = 1;
            DONE: load_gcd = 1;
            default;
        endcase
    end

endmodule
