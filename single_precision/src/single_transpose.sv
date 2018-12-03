`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 07:45:10 PM
// Design Name: 
// Module Name: single_transpose
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


module single_transpose
#(
parameter WIDTH = 10,
parameter HEIGHT = 10
)
(
input [31:0] m_in[WIDTH][HEIGHT],
output [31:0] m_out[HEIGHT][WIDTH]
);

generate
  genvar i, j;
  for (i = 0; i < WIDTH; i = i + 1)
    for (j = 0; j < HEIGHT; j = j + 1)
      assign m_out[j][i] = m_in[i][j];
endgenerate

endmodule
