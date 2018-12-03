`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:16:02 AM
// Design Name: 
// Module Name: single_max
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


module single_max
(
input rstn,
input clk,
input [31:0] a,
input [31:0] b,
output reg [31:0] c
);

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= (a[31] != b[31]) ?
                // Different signs
                (a[31] == 1'b0) ?
                    a :
                    b :
                (a[31] == 1'b0) ?
                    // Both positive
                    (a[30:23] > b[30:23]) ?
                        a :
                        (b[30:23] > a[30:23]) ? 
                            b :
                                (a[22:0] > b[22:0]) ?
                                a :
                                b :
                    // Both negative
                    (a[30:23] > b[30:23]) ?
                        b :
                        (b[30:23] > a[30:23]) ? 
                            a :
                                (a[22:0] > b[22:0]) ?
                                b :
                                a ;                                
endmodule
