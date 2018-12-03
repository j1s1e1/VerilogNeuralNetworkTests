`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 02:58:05 PM
// Design Name: 
// Module Name: half_softmax_v
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


module half_softmax_v
#(
parameter WIDTH = 8
)
(
input rstn,
input clk,
input start,
input [15:0] vector_a[WIDTH],
output done,
output [15:0] vector_c[WIDTH]
);

wire [15:0] max;
wire [15:0] vector_a_delay_max[WIDTH];
wire [15:0] a_minus_max[WIDTH];
wire [15:0] exp_a_minus_max[WIDTH];
wire [15:0] sum_exp_a_minus_max;
wire [15:0] exp_a_minus_max_delay_sum[WIDTH];

wire out_valid_max;
wire out_valid_a_minus_max;
wire out_valid_exp_a_minus_max;
wire out_valid_sum_exp_a_minus_max;

localparam MAX_LEVELS = $clog2(WIDTH);
localparam SUM_LEVELS = $clog2(WIDTH);

half_max_v #(.WIDTH(WIDTH))
half_max_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(start),
.vector_a(vector_a),
.out_valid(out_valid_max),
.c(max)
);

delay_v #(.DELAY(MAX_LEVELS), .WIDTH(16), .LENGTH(WIDTH))
delay_v_vector_a_max
(
.rstn(rstn),
.clk(clk),
.a(vector_a),
.c(vector_a_delay_max)
);

half_add_v_h #(.WIDTH(WIDTH))
half_add_v_h1
(
.rstn(rstn),
.clk(clk),
.start(out_valid_max),
.vector_a(vector_a_delay_max),
.b({~max[15],max[14:0]}),
.done(out_valid_a_minus_max),
.vector_c(a_minus_max)
);

half_exp_v #(.WIDTH(WIDTH))
half_exp_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_a_minus_max),
.vector_a(a_minus_max),
.out_valid(out_valid_exp_a_minus_max),
.vector_c(exp_a_minus_max)
);

half_sum_v #(.WIDTH(WIDTH))
half_sum_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_exp_a_minus_max),
.vector_a(exp_a_minus_max),
.out_valid(out_valid_sum_exp_a_minus_max),
.c(sum_exp_a_minus_max)
);

delay_v #(.DELAY(SUM_LEVELS), .WIDTH(16), .LENGTH(WIDTH))
delay_v_exp_a_minus_max_sum
(
.rstn(rstn),
.clk(clk),
.a(exp_a_minus_max),
.c(exp_a_minus_max_delay_sum)
);

half_divide_v_h #(.WIDTH(WIDTH))
half_divide_v_h1
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
