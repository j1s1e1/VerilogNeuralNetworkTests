`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 07:40:08 PM
// Design Name: 
// Module Name: single_dot_v_v
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


module single_dot_v_v
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
output [31:0] c
);

reg [$clog2(WIDTH):0] count;
reg [31:0] a;
reg [31:0] b;
reg clear;
reg in_valid;
reg [2:0] done_count;

assign done = (done_count == 4);

always @(posedge clk)
  if (start)
    clear <= 1;
  else
    clear <= 0;
    
always @(posedge clk)
  if (count < WIDTH)
    in_valid <= 1;
  else
    in_valid <= 0;
    
always @(posedge clk)
  if (count < WIDTH)
    a <= vector_a[count];
  else
    a <= 0;    
    
always @(posedge clk)
  if (count < WIDTH)
    b <= vector_b[count];
  else
    b <= 0;      

always @(posedge clk)
  if (!rstn)
    count <= WIDTH + 1;
  else
    if (start)
      count <= 0;
    else
      begin
        count <= count;
        if (count < WIDTH)
          count <= count + 1;
      end
always @(posedge clk)
  if (!rstn)
    done_count <= 0;      
  else
    begin
      done_count <= done_count;
      if (start)
        done_count <= 0;
      else
        if (count == WIDTH)
          if (done_count < 4)
            done_count <= done_count +1;
    end
      
single_multiply_accumulate single_multiply_accumulate1(
.rstn(rstn),
.clk(clk),
.clear(clear),
.in_valid(in_valid),
.a(a),
.b(b),
.c(c)
);

endmodule
