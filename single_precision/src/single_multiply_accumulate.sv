`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 07:42:32 PM
// Design Name: 
// Module Name: single_multiply_accumulate
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


module single_multiply_accumulate(
input rstn,
input clk,
input clear,
input in_valid,
input [31:0] a,
input [31:0] b,
output reg [31:0] c
);

wire [31:0] product;
wire [31:0] sum;
wire out_valid_mult;
wire out_valid_sum;
wire [31:0] a_in;

assign a_in = (out_valid_sum) ? sum : c;

always @(posedge clk)
  if (!rstn | clear)
    c <= 0;
  else
    if (out_valid_sum)
      c <= sum;
    else
      c <= c;

single_multiply single_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(b),
.out_valid(out_valid_mult),
.c(product)
);      

single_add_1clk single_add_1clk1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_mult),
.a(a_in),
.b(product),
.out_valid(out_valid_sum),
.c(sum)
);

endmodule
