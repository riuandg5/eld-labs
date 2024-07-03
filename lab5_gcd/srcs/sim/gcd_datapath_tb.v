`timescale 1ns / 1ps

module gcd_datapath_tb;
    reg clk, reset;
    reg [3:0] a, b;
    reg sel_a, sel_b, load_a, load_b, load_gcd;
    wire flag_eq, flag_lt;
    wire [3:0] gcd;

    wire [3:0] amb, bma, mux_a, mux_b, reg_a, reg_b;

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
        .gcd(gcd),
        .debug({amb, bma, mux_a, mux_b, reg_a, reg_b})
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;

        reset = 1;
        a = 0;  b = 0;
        sel_a = 0; sel_b = 0;
        load_a = 0; load_b = 0;
        load_gcd = 0;

        #5 reset = 0;

        #5 a = 3;  b = 7;
        sel_a = 1; sel_b = 1;
        load_a = 1; load_b = 1; // 3, 7

        #20 sel_a = 0; sel_b = 0;
        load_a = 0; load_b = 1; // 3, 4

        #20 load_a = 0; load_b = 1; // 3, 1

        #20 load_a = 1; load_b = 0; // 2, 1

        #20 load_a = 1; load_b = 0; // 1, 1

        #20 load_a = 0; load_b = 0;
        load_gcd = 1;

        #5 reset = 1;
        a = 0;  b = 0;
        sel_a = 0; sel_b = 0;
    end
endmodule
