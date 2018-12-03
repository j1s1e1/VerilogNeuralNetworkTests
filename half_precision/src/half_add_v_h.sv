`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:06:40 AM
// Design Name: 
// Module Name: half_add_v_s
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


module half_add_v_h
#(
parameter WIDTH = 10
)
(
input rstn,
input clk,
input start,
input [15:0] vector_a[WIDTH],
input [15:0] b,
output done,
output [15:0] vector_c[WIDTH]
);

wire [WIDTH-1:0] done_array;
assign done = done_array[0];

generate
  genvar g;
  for (g = 0; g < WIDTH; g = g + 1)
    half_add half_add_array(
    .rstn(rstn),
    .clk(clk),
    .in_valid(start),
    .a(vector_a[g]),
    .b(b),
    .out_valid(done_array[g]),
    .c(vector_c[g])
  );
endgenerate

endmodule
