`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 02:54:12 PM
// Design Name: 
// Module Name: half_sigmoid
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


module half_sigmoid(
input rstn,
input clk,
input in_valid,
input [15:0] a,
output out_valid,
output [15:0] c
);

wire [15:0] m_a;
wire [15:0] exp_m_a;
wire [15:0] exp_m_a_p1;

wire out_valid_exp;
wire out_valid_exp_m_ap1;

assign m_a = (a[14:10]==0) ?
                0:
                {{~a[15],a[14:0]}};

half_exp half_exp1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(m_a),
.out_valid(out_valid_exp),
.c(exp_m_a)
);

half_add half_add(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_exp),
.a(exp_m_a),
.b(16'h3c00), //  $shortrealtobits(1.0)),
.out_valid(out_valid_exp_m_ap1),
.c(exp_m_a_p1)
);

half_divide half_divide1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_exp_m_ap1),
.a(16'h3c00), //  $shortrealtobits(1.0)),
.b(exp_m_a_p1),
.out_valid(out_valid),
.c(c)
);

endmodule
