`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 11:03:31 AM
// Design Name: 
// Module Name: half_pade_approximation_exp
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


module half_pade_approximation_exp(
input rstn,
input clk,
input [15:0] fpart,
output [15:0] x
);

wire [15:0] fpart_sqr;
wire [15:0] fm_exp2_q[2];
wire [15:0] fm_exp2_p[3];
wire [15:0] px,px2,px3,px4,px5;
wire [15:0] qx,qx2,qx3;
wire [15:0] qx3_m_px5;
wire [15:0] px5_d_qx3_m_px5;
wire [15:0] px5_d_qx3_m_px5_m_2;

wire [15:0] px5_d1, qx3_d4;
wire [15:0] fpart_sqr_d1, fpart_sqr_d3;
wire [15:0] fpart_d8;

assign fm_exp2_q[0] = 16'h5b49; // $shortrealtobits(2.33184211722314911771e2);
assign fm_exp2_q[1] = 16'h6c44; // $shortrealtobits(4.36821166879210612817e3);

assign fm_exp2_p[0] = 16'h25e9; // $shortrealtobits(2.30933477057345225087e-2);
assign fm_exp2_p[1] = 16'h4d0c; // $shortrealtobits(2.02020656693165307700e1);
assign fm_exp2_p[2] = 16'h65e9; // $shortrealtobits(1.51390680115615096133e3);

half_multiply half_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fpart),
.b(fpart),
.out_valid(),
.c(fpart_sqr)
);      

half_multiply half_multiply2(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fm_exp2_p[0]),
.b(fpart_sqr),
.out_valid(),
.c(px)
); 

half_add half_add1(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px),
.b(fm_exp2_p[1]),
.out_valid(),
.c(px2)
);

half_add half_add2(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fpart_sqr),
.b(fm_exp2_q[0]),
.out_valid(),
.c(qx)
);

delay #(.DELAY(1), .WIDTH(16))
delay_fpart_sqr1
(
.rstn(rstn),
.clk(clk),
.a(fpart_sqr),
.c(fpart_sqr_d1)
); 

delay #(.DELAY(3), .WIDTH(16))
delay_fpart_sqr3
(
.rstn(rstn),
.clk(clk),
.a(fpart_sqr),
.c(fpart_sqr_d3)
); 

half_multiply half_multiply3(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px2),
.b(fpart_sqr_d3),
.out_valid(),
.c(px3)
); 

half_add half_add3(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px3),
.b(fm_exp2_p[2]),
.out_valid(),
.c(px4)
);

half_multiply half_multiply4(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx),
.b(fpart_sqr_d1),
.out_valid(),
.c(qx2)
); 

half_add half_add4(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx2),
.b(fm_exp2_q[1]),
.out_valid(),
.c(qx3)
);

delay #(.DELAY(8), .WIDTH(16))
delay_fpart_8
(
.rstn(rstn),
.clk(clk),
.a(fpart),
.c(fpart_d8)
); 

half_multiply half_multiply5(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px4),
.b(fpart_d8),
.out_valid(),
.c(px5)
); 

delay #(.DELAY(4), .WIDTH(16))
delay_qx3_d4
(
.rstn(rstn),
.clk(clk),
.a(qx3),
.c(qx3_d4)
); 

delay #(.DELAY(1), .WIDTH(16))
delay_px5_d1
(
.rstn(rstn),
.clk(clk),
.a(px5),
.c(px5_d1)
); 

half_add half_add5(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx3_d4),
.b({~px5[15],px5[14:0]}),
.out_valid(),
.c(qx3_m_px5)
);

half_divide half_divide1(
.rstn(rstn),
.clk(clk),
.a(px5_d1),
.b(qx3_m_px5),
.c(px5_d_qx3_m_px5)
);

half_multiply half_multiply6(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(16'h4000),  // $shortrealtobits(2.0)),
.b(px5_d_qx3_m_px5),
.out_valid(),
.c(px5_d_qx3_m_px5_m_2)
); 

half_add half_add6(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(16'h3c00), //  $shortrealtobits(1.0)),
.b(px5_d_qx3_m_px5_m_2),
.out_valid(),
.c(x)
);

endmodule
