`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:08:54 AM
// Design Name: 
// Module Name: single_softmax_v
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module single_softmax_v
#(
parameter WIDTH = 8
)
(
input rstn,
input clk,
input start,
input [31:0] vector_a[WIDTH],
output done,
output [31:0] vector_c[WIDTH]
);

wire [31:0] max;
wire [31:0] vector_a_delay_max[WIDTH];
wire [31:0] a_minus_max[WIDTH];
wire [31:0] exp_a_minus_max[WIDTH];
wire [31:0] sum_exp_a_minus_max;
wire [31:0] exp_a_minus_max_delay_sum[WIDTH];

wire out_valid_max;
wire out_valid_a_minus_max;
wire out_valid_exp_a_minus_max;
wire out_valid_sum_exp_a_minus_max;

localparam MAX_LEVELS = $clog2(WIDTH);
localparam SUM_LEVELS = $clog2(WIDTH);

single_max_v #(.WIDTH(WIDTH))
single_max_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(start),
.vector_a(vector_a),
.out_valid(out_valid_max),
.c(max)
);

delay_v #(.DELAY(MAX_LEVELS), .WIDTH(32), .LENGTH(WIDTH))
delay_v_vector_a_max
(
.rstn(rstn),
.clk(clk),
.a(vector_a),
.c(vector_a_delay_max)
);

single_add_v_s #(.WIDTH(WIDTH))
single_add_v_s1
(
.rstn(rstn),
.clk(clk),
.start(out_valid_max),
.vector_a(vector_a_delay_max),
.b({~max[31],max[30:0]}),
.done(out_valid_a_minus_max),
.vector_c(a_minus_max)
);

single_exp_v #(.WIDTH(WIDTH))
single_exp_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_a_minus_max),
.vector_a(a_minus_max),
.out_valid(out_valid_exp_a_minus_max),
.vector_c(exp_a_minus_max)
);

single_sum_v #(.WIDTH(WIDTH))
single_sum_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_exp_a_minus_max),
.vector_a(exp_a_minus_max),
.out_valid(out_valid_sum_exp_a_minus_max),
.c(sum_exp_a_minus_max)
);

delay_v #(.DELAY(SUM_LEVELS), .WIDTH(32), .LENGTH(WIDTH))
delay_v_exp_a_minus_max_sum
(
.rstn(rstn),
.clk(clk),
.a(exp_a_minus_max),
.c(exp_a_minus_max_delay_sum)
);

single_divide_v_s #(.WIDTH(WIDTH))
single_divide_v_s1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_sum_exp_a_minus_max),
.vector_a(exp_a_minus_max_delay_sum),
.b(sum_exp_a_minus_max),
.out_valid(done),
.vector_c(vector_c)
);

endmodule
