`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 11:11:38 AM
// Design Name: 
// Module Name: half_exp_tb
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


module half_exp_tb(
);

`include "half_conversions.h"

reg rstn;
reg clk;
reg in_valid;
reg [15:0] a;
wire [15:0] c;

wire [31:0] a_single;
wire [31:0] c_single;

assign a_single = SingleFromHalf(a);
assign c_single = SingleFromHalf(c);


reg [31:0] a_single2;
reg [4:0] a_exp;

task ExpHalf;
  input real a_real;
  begin
    a <= RealToHalf(a_real);
    @(posedge clk);
  end
endtask

initial
  begin
    rstn <= 1;
    in_valid <= 0;
    a <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    in_valid <= 1;
    ExpHalf(-5.5);
    ExpHalf(-0.5);
    ExpHalf(0.5);
    ExpHalf(-0.25);
    ExpHalf(0.25);           
    ExpHalf(1.0);
    ExpHalf(2.0);
    ExpHalf(3.0);
    ExpHalf(1.234567);
    ExpHalf(4.5678);
    ExpHalf(-3.21);
    in_valid <= 0;
    a <= 0;
    @(posedge clk);
    repeat (150) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

half_exp half_exp1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.out_valid(out_valid),
.c(c)
);


endmodule
