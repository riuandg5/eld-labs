`timescale 1ns / 1ps

module gcd (
    input clk,
    input reset,
    input start,
    input [3:0] a,
    input [3:0] b,
    output [3:0] gcd
);

    wire sel_a, sel_b, load_a, load_b, load_gcd, flag_eq, flag_lt;

    gcd_datapath gcd_dp1 (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .sel_a(sel_a),
        .sel_b(sel_b),
        .load_a(load_a),
        .load_b(load_b),
        .load_gcd(load_gcd),
        .flag_eq(flag_eq),
        .flag_lt(flag_lt),
        .gcd(gcd)
    );

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
        .load_gcd(load_gcd)
    );

endmodule
