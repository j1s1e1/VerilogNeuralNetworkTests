`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 02:38:47 PM
// Design Name: 
// Module Name: half_multiply_tb
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


module half_multiply_tb(
);

`include "half_conversions.h"

reg rstn;
reg clk;
reg in_valid;
reg [15:0] a;
reg [15:0] b;
wire out_valid;;
wire [15:0] c;
wire [31:0] a_single;
wire [31:0] b_single;
wire [31:0] c_single;

assign a_single = SingleFromHalf(a);
assign b_single = SingleFromHalf(b);
assign c_single = SingleFromHalf(c);

task MultiplyHalf;
  input real a_real;
  input real b_real;
  begin
    a <= RealToHalf(a_real);
    b <= RealToHalf(b_real);
    @(posedge clk);
  end
endtask
    
initial
  begin
    rstn <= 1;
    in_valid <= 0;
    a <= 0;
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    a <= 0;
    b <= 0;
    @(posedge clk);
    in_valid <= 1;
    MultiplyHalf(1.5, 1.5);
    MultiplyHalf(-1.5, -1.5);
    MultiplyHalf(1.5e-2, 1.5);
    MultiplyHalf(2.0, -1.5);
    MultiplyHalf(1.5, 0.15);
    MultiplyHalf(1.5, 0.75);
    MultiplyHalf(1.765e3, 1.875e-3);
    MultiplyHalf(1.5, -1.5);
    MultiplyHalf(150.0, -175.0);
    a <= 0;
    b <= 0;
    in_valid <= 0;
    @(posedge clk);
    @(posedge clk);
    a <= 0;
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    $stop;
  end    
    
initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

half_multiply half_multiply1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(b),
.out_valid(out_valid),
.c(c)
);

endmodule
