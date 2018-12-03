`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:36:31 AM
// Design Name: 
// Module Name: half_exp
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


module half_exp(
input rstn,
input clk,
input in_valid,
input [15:0] a,
output out_valid,
output [15:0] c
);

wire out_valid_m1;
wire [15:0] a_x_log2e;
wire [15:0] a_in;

assign a_in = (a[15] == 1) ?
                 (a[14:10] > 17) ?
                    16'b1100100000000000 : // min value -8 to prevent calulation underflow
                    a :
                 (a[14:10] > 17) ?
                    16'b0100100000000000 : // max value 8 to prevent calulation overflow
                    a;

half_multiply half_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a_in),
.b(16'h3dc5), //$shortrealtobits(1.44269504088896)),
.out_valid(out_valid_m1),
.c(a_x_log2e)
); 

half_fm_exp2 half_fm_exp2_1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_m1),
.a(a_x_log2e),
.out_valid(out_valid),
.c(c)
);

endmodule
