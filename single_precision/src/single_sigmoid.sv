`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 03:20:11 AM
// Design Name: 
// Module Name: single_sigmoid
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


module single_sigmoid(
input rstn,
input clk,
input in_valid,
input [31:0] a,
output out_valid,
output [31:0] c
);

wire [31:0] m_a;
wire [31:0] exp_m_a;
wire [31:0] exp_m_a_p1;

wire out_valid_exp;
wire out_valid_exp_m_ap1;

assign m_a = (a[30:23]==0) ?
                0:
                {{~a[31],a[30:0]}};

single_exp single_exp1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(m_a),
.out_valid(out_valid_exp),
.c(exp_m_a)
);

single_add_1clk single_add_1clk1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_exp),
.a(exp_m_a),
.b(32'h3f800000), //  $shortrealtobits(1.0)),
.out_valid(out_valid_exp_m_ap1),
.c(exp_m_a_p1)
);

single_divide single_divide1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_exp_m_ap1),
.a(32'h3f800000), //  $shortrealtobits(1.0)),
.b(exp_m_a_p1),
.out_valid(out_valid),
.c(c)
);

endmodule
