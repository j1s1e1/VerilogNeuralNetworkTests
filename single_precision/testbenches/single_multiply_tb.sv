`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:52:50 AM
// Design Name: 
// Module Name: single_multiply_tb
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


module single_multiply_tb(
);

reg rstn;
reg clk;
reg [31:0] a;
reg [31:0] b;
wire [31:0] c;

task Multiply;
  input real ain;
  input real bin;
  begin
    a <= $shortrealtobits(ain);
    b <= $shortrealtobits(bin);
    @(posedge clk);
  end
endtask
    
initial
  begin
    rstn <= 1;
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
    Multiply(1.0, 5.0);
    Multiply(0.0, 5.0);
    Multiply(1e15, 8e2);
    Multiply(4e-12, 6e3);
    Multiply(500, -500);
    @(posedge clk);
    a <= 0;
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $stop;
  end    
    
initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end    
    
single_multiply single_multiply1(
.rstn(rstn),
.clk(clk),
.a(a),
.b(b),
.c(c)
);       

endmodule
