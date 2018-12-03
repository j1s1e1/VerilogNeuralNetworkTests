`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:41:51 AM
// Design Name: 
// Module Name: single_exp_v
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


module single_exp_v
#(
parameter WIDTH = 10
)
(
input rstn,
input clk,
input in_valid,
input [31:0] vector_a[WIDTH],
output out_valid,
output [31:0] vector_c[WIDTH]
);

wire [WIDTH-1:0] out_valid_array;
assign out_valid = out_valid_array[0];

generate
  genvar g;
  for (g = 0; g < WIDTH; g = g + 1)
    single_exp single_exp1(
    .rstn(rstn),
    .clk(clk),
    .in_valid(in_valid),
    .a(vector_a[g]),
    .out_valid(out_valid_array[g]),
    .c(vector_c[g])
  );
endgenerate

endmodule
