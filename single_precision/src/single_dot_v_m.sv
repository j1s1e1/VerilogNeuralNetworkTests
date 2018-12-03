`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 07:37:55 PM
// Design Name: 
// Module Name: single_dot_v_m
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


module single_dot_v_m
#(
parameter WIDTH = 10,
parameter HEIGHT = 10
)
(
input rstn,
input clk,
input start,
input [31:0] vector[WIDTH],
input [31:0] matrix[WIDTH][HEIGHT],
output done,
output [31:0] vector_out[HEIGHT]
);

wire [31:0] matrixT[HEIGHT][WIDTH];
wire [HEIGHT-1:0] done_array;

assign done = done_array[0];

generate
  genvar g;
  for (g = 0; g < HEIGHT; g = g + 1)
    single_dot_v_v #(.WIDTH(WIDTH))
    single_dot_v_v_array
    (
        .rstn(rstn),
        .clk(clk),
        .start(start),
        .vector_a(vector),
        .vector_b(matrixT[g]),
        .done(done_array[g]),
        .c(vector_out[g])
    );
endgenerate

single_transpose #(.WIDTH(WIDTH), .HEIGHT(HEIGHT))
single_transpose1
(
.m_in(matrix),
.m_out(matrixT)
);

endmodule
