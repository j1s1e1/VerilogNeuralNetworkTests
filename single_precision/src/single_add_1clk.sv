`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:21:10 AM
// Design Name: 
// Module Name: single_add_1clk
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


module single_add_1clk(
input rstn,
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
output reg out_valid,
output wire [31:0] c
);

localparam SUM_SHIFT = 40 - 25;

reg [31:0] c_int;

wire [39:0] sum;

wire a_zero;
wire b_zero;
wire expa_gt_expb;
wire expb_gt_expa;
wire mana_gt_manb;
wire manb_gt_mana;
wire a_gt_b;
wire [5:0] ashift;
wire [5:0] bshift;
wire minus;
wire [5:0] leading_zeros;

assign c = c_int;

assign a_zero = (a == 0); 
assign b_zero = (b == 0);     
assign expa_gt_expb = (a[30:23] > b[30:23]) ? 1 : 0;
assign expb_gt_expa = (b[30:23] > a[30:23]) ? 1 : 0;
assign mana_gt_manb = (a[22:0] > b[22:0]) ? 1 : 0;
assign manb_gt_mana = (b[22:0] > a[22:0]) ? 1 : 0;
assign a_gt_b = (expa_gt_expb | (!expb_gt_expa & mana_gt_manb));
assign ashift = expb_gt_expa ? 
                    (b[30:23] - a[30:23] < 24) ? b[30:23] - a[30:23] : 24
                    : 0;
assign bshift = expa_gt_expb ? 
                    (a[30:23] - b[30:23] < 24) ? a[30:23] - b[30:23] : 24                     
                    : 0;                    
assign minus = a[31] != b[31];  

always @(posedge clk)
  out_valid <= in_valid;                    

always @(posedge clk)
  if (!rstn)
    c_int[31] <= 0;
  else
    c_int[31] <= (a[31] == b[31]) ? a[31] :
             expa_gt_expb ? a[31] :
             expb_gt_expa ? b[31] :
             mana_gt_manb ? a[31] : 
             manb_gt_mana ? b[31] : 0;
             
always @(posedge clk)
  if (!rstn)
    c_int[30:23] <= 0;
  else             
    c_int[30:23] <= (leading_zeros < 40) ?
                    expb_gt_expa ?
                    b[30:23] + (8'b1 - leading_zeros):
                    a[30:23] + (8'b1 - leading_zeros):
                    0;
                
always @(posedge clk)
  if (!rstn)
    c_int[22:0] <= 0;
  else
    c_int[22:0] <= (leading_zeros < 40) ?
                       (leading_zeros < 16) ?
                            sum >> (16 - leading_zeros):
                            sum << (leading_zeros - 16): 
                       0;

assign sum = (minus) ?
                (a_gt_b) ?
                    ({1'b1,a[22:0]} << (SUM_SHIFT - ashift)) - ({1'b1,b[22:0]} << (SUM_SHIFT - bshift)) :
                    ({1'b1,b[22:0]} << (SUM_SHIFT - bshift)) - ({1'b1,a[22:0]} << (SUM_SHIFT - ashift)) :
                (a_zero) ?
                    (b_zero) ?
                         0 :
                    ({1'b1,b[22:0]} << (SUM_SHIFT - bshift)) :
                (b_zero) ?
                    ({1'b1,a[22:0]} << (SUM_SHIFT - ashift)) :
                    ({1'b1,a[22:0]} << (SUM_SHIFT - ashift)) + ({1'b1,b[22:0]} << (SUM_SHIFT - bshift));            

leading_zero_count #(.WIDTH(40))
leading_zero_count1
(
.a(sum),
.c(leading_zeros)
);          

endmodule
