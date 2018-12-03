`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2018 11:04:54 PM
// Design Name: 
// Module Name: half_sigmoid_tb
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


module half_sigmoid_tb(
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

task SigmoidHalf;
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
    SigmoidHalf(-5.5);
    SigmoidHalf(-0.5);
    SigmoidHalf(0.5);
    SigmoidHalf(-0.25);
    SigmoidHalf(0.25);           
    SigmoidHalf(1.0);
    SigmoidHalf(2.0);
    SigmoidHalf(3.0);
    SigmoidHalf(1.234567);
    SigmoidHalf(4.5678);
    SigmoidHalf(-3.21);
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

half_sigmoid half_sigmoid1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.out_valid(out_valid),
.c(c)
);

endmodule
