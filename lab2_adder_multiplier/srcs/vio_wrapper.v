`timescale 1ns / 1ps

module vio_wrapper(
    input sys_clk
    );
    
    wire [2:0] a, b;
    wire [5:0] m;
    
    vio v1 (
        .clk(sys_clk),
        .probe_in0(m),
        .probe_out0(a),
        .probe_out1(b)
    );
    
    multiplier_3bit m3b1 (.a(a), .b(b), .m(m));
endmodule
