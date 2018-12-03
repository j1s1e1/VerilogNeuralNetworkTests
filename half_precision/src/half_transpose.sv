`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:29:41 AM
// Design Name: 
// Module Name: half_transpose
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


module half_transpose
#(
parameter WIDTH = 10,
parameter HEIGHT = 10
)
(
input [15:0] m_in[WIDTH][HEIGHT],
output [15:0] m_out[HEIGHT][WIDTH]
);

generate
  genvar i, j;
  for (i = 0; i < WIDTH; i = i + 1)
    for (j = 0; j < HEIGHT; j = j + 1)
      assign m_out[j][i] = m_in[i][j];
endgenerate

endmodule
