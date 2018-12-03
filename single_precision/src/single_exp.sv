`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:43:24 AM
// Design Name: 
// Module Name: single_exp
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


module single_exp(
input rstn,
input clk,
input in_valid,
input [31:0] a,
output out_valid,
output [31:0] c
);

wire out_valid_m1;

wire [31:0] a_x_log2e;

single_multiply single_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b($shortrealtobits(1.44269504088896)),
.out_valid(out_valid_m1),
.c(a_x_log2e)
); 

single_fm_exp2 single_fm_exp2_1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_m1),
.a(a_x_log2e),
.out_valid(out_valid),
.c(c)
);

endmodule
