`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:21:39 AM
// Design Name: 
// Module Name: half_divide_v_h
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


module half_divide_v_h
#(
parameter WIDTH = 10
)
(
input rstn,
input clk,
input in_valid,
input [15:0] vector_a[WIDTH],
input [15:0] b,
output out_valid,
output [15:0] vector_c[WIDTH]
);

wire [WIDTH-1:0] out_valid_array;

assign out_valid = out_valid_array[0];

generate
  genvar g;
  for (g = 0; g < WIDTH; g = g + 1)
    half_divide half_divide1(
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
