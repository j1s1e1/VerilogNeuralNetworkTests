`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 02:09:28 AM
// Design Name: 
// Module Name: single_pade_approximation_exp
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


module single_pade_approximation_exp(
input rstn,
input clk,
input [31:0] fpart,
output [31:0] x
);

wire [31:0] fpart_sqr;
wire [31:0] fm_exp2_q[2];
wire [31:0] fm_exp2_p[3];
wire [31:0] px,px2,px3,px4,px5;
wire [31:0] qx,qx2,qx3;
wire [31:0] qx3_m_px5;
wire [31:0] px5_d_qx3_m_px5;
wire [31:0] px5_d_qx3_m_px5_m_2;

wire [31:0] px5_d1, qx3_d4;
wire [31:0] fpart_sqr_d1, fpart_sqr_d3;
wire [31:0] fpart_d8;

assign fm_exp2_q[0] = 32'h43692f28; // $shortrealtobits(2.33184211722314911771e2);
assign fm_exp2_q[1] = 32'h458881b1; // $shortrealtobits(4.36821166879210612817e3);

assign fm_exp2_p[0] = 32'h3cbd2e43; // $shortrealtobits(2.30933477057345225087e-2);
assign fm_exp2_p[1] = 32'h41a19dd5; // $shortrealtobits(2.02020656693165307700e1);
assign fm_exp2_p[2] = 32'h44bd3d05; // $shortrealtobits(1.51390680115615096133e3);

single_multiply single_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fpart),
.b(fpart),
.out_valid(),
.c(fpart_sqr)
);      

single_multiply single_multiply2(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fm_exp2_p[0]),
.b(fpart_sqr),
.out_valid(),
.c(px)
); 

single_add_1clk single_add_1clk1(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px),
.b(fm_exp2_p[1]),
.out_valid(),
.c(px2)
);

single_add_1clk single_add_1clk2(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fpart_sqr),
.b(fm_exp2_q[0]),
.out_valid(),
.c(qx)
);

delay #(.DELAY(1), .WIDTH(32))
delay_fpart_sqr1
(
.rstn(rstn),
.clk(clk),
.a(fpart_sqr),
.c(fpart_sqr_d1)
); 

delay #(.DELAY(3), .WIDTH(32))
delay_fpart_sqr3
(
.rstn(rstn),
.clk(clk),
.a(fpart_sqr),
.c(fpart_sqr_d3)
); 

single_multiply single_multiply3(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px2),
.b(fpart_sqr_d3),
.out_valid(),
.c(px3)
); 

single_add_1clk single_add_1clk3(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px3),
.b(fm_exp2_p[2]),
.out_valid(),
.c(px4)
);

single_multiply single_multiply4(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx),
.b(fpart_sqr_d1),
.out_valid(),
.c(qx2)
); 

single_add_1clk single_add_1clk4(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx2),
.b(fm_exp2_q[1]),
.out_valid(),
.c(qx3)
);

delay #(.DELAY(8), .WIDTH(32))
delay_fpart_8
(
.rstn(rstn),
.clk(clk),
.a(fpart),
.c(fpart_d8)
); 

single_multiply single_multiply5(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px4),
.b(fpart_d8),
.out_valid(),
.c(px5)
); 

delay #(.DELAY(4), .WIDTH(32))
delay_qx3_d4
(
.rstn(rstn),
.clk(clk),
.a(qx3),
.c(qx3_d4)
); 

delay #(.DELAY(1), .WIDTH(32))
delay_px5_d1
(
.rstn(rstn),
.clk(clk),
.a(px5),
.c(px5_d1)
); 

single_add_1clk single_add_1clk5(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx3_d4),
.b({~px5[31],px5[30:0]}),
.out_valid(),
.c(qx3_m_px5)
);

single_divide single_divide1(
.rstn(rstn),
.clk(clk),
.a(px5_d1),
.b(qx3_m_px5),
.c(px5_d_qx3_m_px5)
);

single_multiply single_multiply6(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(32'h40000000),  // $shortrealtobits(2.0)),
.b(px5_d_qx3_m_px5),
.out_valid(),
.c(px5_d_qx3_m_px5_m_2)
); 

single_add_1clk single_add_1clk6(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(32'h3f800000), //  $shortrealtobits(1.0)),
.b(px5_d_qx3_m_px5_m_2),
.out_valid(),
.c(x)
);

endmodule
