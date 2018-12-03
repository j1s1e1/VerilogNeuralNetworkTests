`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 02:01:29 AM
// Design Name: 
// Module Name: single_fm_exp2
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


module single_fm_exp2(
input rstn,
input clk,
input in_valid,
input [31:0] a,
output out_valid,
output reg [31:0] c
);

reg [31:0] a_d;
reg [31:0] a_d2;

wire [31:0] ipart;
wire [31:0] fpart;
wire [31:0] epart;
wire [31:0] x;
wire [31:0] epart_d;

wire [31:0] pos_or_neg_one_half;
wire [31:0] a_plus_or_minus_one_half;    

wire out_valid_sa1; 
wire out_valid_ips;
wire out_valid_sa2;
wire out_valid_2ips;
                            
assign pos_or_neg_one_half = (a[31]) ?
        32'hbf000000 : // $shortrealtobits(-0.5) :
        32'h3f000000;  // $shortrealtobits(0.5);       
        
always @(posedge clk)
  a_d <= a;                                                                                     

always @(posedge clk)
  a_d2 <= a_d;                    

single_add_1clk single_add_1clk1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(pos_or_neg_one_half),
.out_valid(out_valid_sa1),
.c(a_plus_or_minus_one_half)
);
                              
single_integer_part single_integer_part1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_sa1),
.a(a_plus_or_minus_one_half),
.out_valid(out_valid_ips),
.c(ipart)
); 

single_add_1clk single_add_1clk2(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_ips),
.a(a_d2),
.b({~ipart[31],ipart[30:0]}),
.out_valid(out_valid_sa2),
.c(fpart)
);

single_two_int_power single_two_int_power1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_ips),
.a(ipart),
.out_valid(out_valid_2ips),
.c(epart)
);

single_pade_approximation_exp single_pade_approximation_exp1(
.rstn(rstn),
.clk(clk),
.fpart(fpart),
.x(x)
);

delay #(.DELAY(64), .WIDTH(32))
delay_epart
(
.rstn(rstn),
.clk(clk),
.a(epart),
.c(epart_d)
); 

delay #(.DELAY(64), .WIDTH(1))
delay_outv
(
.rstn(rstn),
.clk(clk),
.a(out_valid_2ips),
.c(out_valid_epart_d)
); 


single_multiply single_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_epart_d),
.a(epart_d),
.b(x),
.out_valid(out_valid),
.c(c)
);

endmodule
