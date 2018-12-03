`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:27:45 AM
// Design Name: 
// Module Name: half_multiply_accumulate
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


module half_multiply_accumulate(
input rstn,
input clk,
input clear,
input in_valid,
input [15:0] a,
input [15:0] b,
output reg [15:0] c
);

wire [15:0] product;
wire [15:0] sum;
wire out_valid_mult;
wire out_valid_sum;
wire [15:0] a_in;

assign a_in = (out_valid_sum) ? sum : c;

always @(posedge clk)
  if (!rstn | clear)
    c <= 0;
  else
    if (out_valid_sum)
      c <= sum;
    else
      c <= c;

half_multiply half_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(b),
.out_valid(out_valid_mult),
.c(product)
);      

half_add half_add1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_mult),
.a(a_in),
.b(product),
.out_valid(out_valid_sum),
.c(sum)
);

endmodule
