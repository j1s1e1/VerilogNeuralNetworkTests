`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 07:58:26 PM
// Design Name: 
// Module Name: single_add_v_v
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


module single_add_v_v
#(
parameter WIDTH = 10
)
(
input rstn,
input clk,
input start,
input [31:0] vector_a[WIDTH],
input [31:0] vector_b[WIDTH],
output done,
output [31:0] vector_c[WIDTH]
);

wire [WIDTH-1:0] done_array;

assign done = done_array[0];

generate
  genvar g;
  for (g = 0; g < WIDTH; g = g + 1)
    single_add_1clk single_add_1clk_array(
    .rstn(rstn),
    .clk(clk),
    .in_valid(start),
    .a(vector_a[g]),
    .b(vector_b[g]),
    .out_valid(done_array[g]),
    .c(vector_c[g])
  );
endgenerate

endmodule
