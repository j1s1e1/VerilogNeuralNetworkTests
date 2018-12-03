`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:53:47 AM
// Design Name: 
// Module Name: half_fm_exp2
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


module half_fm_exp2(
input rstn,
input clk,
input in_valid,
input [15:0] a,
output out_valid,
output reg [15:0] c
);

reg [15:0] a_d;
reg [15:0] a_d2;

wire [15:0] ipart;
wire [15:0] fpart;
wire [15:0] epart;
wire [15:0] x;
wire [15:0] epart_d;

wire [15:0] pos_or_neg_one_half;
wire [15:0] a_plus_or_minus_one_half;    

wire out_valid_sa1; 
wire out_valid_ips;
wire out_valid_sa2;
wire out_valid_2ips;
                            
assign pos_or_neg_one_half = (a[15]) ?
        16'hb800 : // $shortrealtobits(-0.5) :
        16'h3800;  // $shortrealtobits(0.5);       
        
always @(posedge clk)
  a_d <= a;                                                                                     

always @(posedge clk)
  a_d2 <= a_d;                    

half_add half_add1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(pos_or_neg_one_half),
.out_valid(out_valid_sa1),
.c(a_plus_or_minus_one_half)
);
                              
half_integer_part half_integer_part1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_sa1),
.a(a_plus_or_minus_one_half),
.out_valid(out_valid_ips),
.c(ipart)
); 

half_add half_add2(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_ips),
.a(a_d2),
.b({~ipart[15],ipart[14:0]}),
.out_valid(out_valid_sa2),
.c(fpart)
);

half_two_int_power half_two_int_power1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_ips),
.a(ipart),
.out_valid(out_valid_2ips),
.c(epart)
);

half_pade_approximation_exp half_pade_approximation_exp1(
.rstn(rstn),
.clk(clk),
.fpart(fpart),
.x(x)
);

delay #(.DELAY(38), .WIDTH(16))
delay_epart
(
.rstn(rstn),
.clk(clk),
.a(epart),
.c(epart_d)
); 

delay #(.DELAY(38), .WIDTH(1))
delay_outv
(
.rstn(rstn),
.clk(clk),
.a(out_valid_2ips),
.c(out_valid_epart_d)
); 


half_multiply half_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_epart_d),
.a(epart_d),
.b(x),
.out_valid(out_valid),
.c(c)
);

endmodule
