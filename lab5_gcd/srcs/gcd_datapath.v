`timescale 1ns / 1ps

module gcd_datapath (
    input clk,
    input reset,
    input [3:0] a,
    input [3:0] b,
    input sel_a,
    input sel_b,
    input load_a,
    input load_b,
    input load_gcd,
    output flag_eq,
    output flag_lt,
    output reg [3:0] gcd,
    output [23:0] debug
);

    wire [3:0] amb, bma, mux_a, mux_b;
    reg [3:0] reg_a, reg_b;
    assign debug = {amb, bma, mux_a, mux_b, reg_a, reg_b};

    assign amb = reg_a - reg_b;
    assign bma = reg_b - reg_a;

    assign mux_a = sel_a ? a : amb;
    assign mux_b = sel_b ? b : bma;

    assign flag_eq = reg_a == reg_b ? 1 : 0;
    assign flag_lt = reg_a < reg_b ? 1 : 0;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            reg_a <= 0; reg_b <= 0;
            gcd <= 0;
        end else begin
            if (load_a) reg_a <= mux_a;
            if (load_b) reg_b <= mux_b;
            if (load_gcd) gcd <= reg_a;
        end
    end

endmodule
