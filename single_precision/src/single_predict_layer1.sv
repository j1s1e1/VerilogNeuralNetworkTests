`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 07:47:53 PM
// Design Name: 
// Module Name: single_predict_layer1
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


module single_predict_layer1
#(
parameter LAYER1_NEURONS = 10,
parameter LAYER2_NEURONS = 10
)
(
input rstn,
input clk,
input start,
input [31:0] x[LAYER1_NEURONS],
input [31:0] W1[LAYER1_NEURONS][LAYER2_NEURONS],
input [31:0] b1[LAYER2_NEURONS],
output done,
output [31:0] l[LAYER2_NEURONS]
);

wire [31:0] x_dot_W1[LAYER2_NEURONS];
wire done_x_dot_W1;
wire [31:0] x_dot_W1_plus_b1[LAYER2_NEURONS];
wire done_x_dot_W1_plus_b1;

single_dot_v_m #(.WIDTH(LAYER1_NEURONS), .HEIGHT(LAYER2_NEURONS))
single_dot_v_m1
(
.rstn(rstn),
.clk(clk),
.start(start),
.vector(x),
.matrix(W1),
.done(done_x_dot_W1),
.vector_out(x_dot_W1)
);

single_add_v_v #(.WIDTH(LAYER2_NEURONS))
single_add_v_v1
(
.rstn(rstn),
.clk(clk),
.start(done_x_dot_W1),
.vector_a(x_dot_W1),
.vector_b(b1),
.done(done_x_dot_W1_plus_b1),
.vector_c(x_dot_W1_plus_b1)
);

single_sigmoid_v #(.WIDTH(LAYER2_NEURONS))
single_sigmoid_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(done_x_dot_W1_plus_b1),
.vector_a(x_dot_W1_plus_b1),
.out_valid(done),
.vector_c(l)
);

endmodule
