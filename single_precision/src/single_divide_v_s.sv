`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 12:26:35 AM
// Design Name: 
// Module Name: single_divide_v_s
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


module single_divide_v_s
#(
parameter WIDTH = 10
)
(
input rstn,
input clk,
input in_valid,
input [31:0] vector_a[WIDTH],
input [31:0] b,
output out_valid,
output [31:0] vector_c[WIDTH]
);

wire [WIDTH-1:0] out_valid_array;

assign out_valid = out_valid_array[0];

generate
  genvar g;
  for (g = 0; g < WIDTH; g = g + 1)
    single_divide single_divide1(
    .rstn(rstn),
    .clk(clk),
    .in_valid(in_valid),
    .a(vector_a[g]),
    .b(b),
    .out_valid(out_valid_array[g]),
    .c(vector_c[g])
  );
endgenerate

endmodule
