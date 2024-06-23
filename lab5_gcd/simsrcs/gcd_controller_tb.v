`timescale 1ns / 1ps

module gcd_controller_tb;
    reg clk, reset, start, flag_eq, flag_lt;
    wire sel_a, sel_b, load_a, load_b, load_gcd;

    wire [2:0] curr_state, next_state;

    gcd_controller gcd_c1 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .flag_eq(flag_eq),
        .flag_lt(flag_lt),
        .sel_a(sel_a),
        .sel_b(sel_b),
        .load_a(load_a),
        .load_b(load_b),
        .load_gcd(load_gcd),
        .debug({curr_state, next_state})
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;

        reset = 1;
        start = 0;
        flag_eq = 1; flag_lt = 0;

        #5 reset = 0;
        start = 1;
        flag_eq = 0; flag_lt = 1;

        #5;

        #60 flag_eq = 0; flag_lt = 0;

        #60; flag_eq = 1; flag_lt = 0;
    end
endmodule
