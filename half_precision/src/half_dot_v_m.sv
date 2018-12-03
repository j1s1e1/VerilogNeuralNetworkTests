`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:23:22 AM
// Design Name: 
// Module Name: half_dot_v_m
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


module half_dot_v_m
#(
parameter WIDTH = 10,
parameter HEIGHT = 10
)
(
input rstn,
input clk,
input start,
input [15:0] vector[WIDTH],
input [15:0] matrix[WIDTH][HEIGHT],
output done,
output [15:0] vector_out[HEIGHT]
);

wire [15:0] matrixT[HEIGHT][WIDTH];
wire [HEIGHT-1:0] done_array;

assign done = done_array[0];

generate
  genvar g;
  for (g = 0; g < HEIGHT; g = g + 1)
    half_dot_v_v #(.WIDTH(WIDTH))
    half_dot_v_v_array
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

half_transpose #(.WIDTH(WIDTH), .HEIGHT(HEIGHT))
half_transpose1
(
.m_in(matrix),
.m_out(matrixT)
);

endmodule
