`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 02:26:30 AM
// Design Name: 
// Module Name: single_exp_tb
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


module single_exp_tb(
);

reg rstn;
reg clk;
reg [31:0] a;
wire [31:0] c;

initial
  begin
    rstn <= 1;
    a <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    a <= $shortrealtobits(-5.5);
    @(posedge clk);
    a <= $shortrealtobits(-0.5);
    @(posedge clk);
    a <= $shortrealtobits(0.5);
    @(posedge clk);
    a <= $shortrealtobits(-0.25);
    @(posedge clk);
    a <= $shortrealtobits(0.25);
    @(posedge clk);            
    a <= $shortrealtobits(1.0);
    @(posedge clk);
    a <= $shortrealtobits(2.0);
    @(posedge clk);
    a <= $shortrealtobits(3.0);
    @(posedge clk);
    a <= $shortrealtobits(1.234567);
    @(posedge clk);
    a <= $shortrealtobits(4.5678);
    @(posedge clk);
    a <= $shortrealtobits(-3.21);
    @(posedge clk);
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

single_exp single_exp1(
.rstn(rstn),
.clk(clk),
.a(a),
.c(c)
);

endmodule
