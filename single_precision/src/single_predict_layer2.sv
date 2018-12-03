`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 11:02:52 PM
// Design Name: 
// Module Name: single_predict_layer2
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


module single_predict_layer2
#(
parameter LAYER2_NEURONS = 10,
parameter OUTPUT_NODES = 10
)
(
input rstn,
input clk,
input start,
input [31:0] l[LAYER2_NEURONS],
input [31:0] W2[LAYER2_NEURONS][OUTPUT_NODES],
input [31:0] b2[OUTPUT_NODES],
output done,
output [31:0] y[OUTPUT_NODES]
);

wire [31:0] l_dot_W2[OUTPUT_NODES];
wire done_l_dot_W2;
wire [31:0] l_dot_W2_plus_b2[OUTPUT_NODES];
wire done_l_dot_W2_plus_b2;

single_dot_v_m #(.WIDTH(LAYER2_NEURONS), .HEIGHT(OUTPUT_NODES))
single_dot_v_m1
(
.rstn(rstn),
.clk(clk),
.start(start),
.vector(l),
.matrix(W2),
.done(done_l_dot_W2),
.vector_out(l_dot_W2)
);

single_add_v_v #(.WIDTH(OUTPUT_NODES))
single_add_v_v1
(
.rstn(rstn),
.clk(clk),
.start(done_l_dot_W2),
.vector_a(l_dot_W2),
.vector_b(b2),
.done(done_l_dot_W2_plus_b2),
.vector_c(l_dot_W2_plus_b2)
);

single_softmax_v #(.WIDTH(OUTPUT_NODES))
single_softmax_v1
(
.rstn(rstn),
.clk(clk),
.start(done_l_dot_W2_plus_b2),
.vector_a(l_dot_W2_plus_b2),
.done(done),
.vector_c(y)
);

endmodule
