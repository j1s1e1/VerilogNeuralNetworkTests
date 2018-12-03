`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:33:15 AM
// Design Name: 
// Module Name: single_add_1clk_tb
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


module single_add_1clk_tb(

    );
    
reg rstn;
reg clk;
reg [31:0] a;
reg [31:0] b;
wire out_valid;;
wire [31:0] c;
    
task AddSingle;
  input real a_real;
  input real b_real;
  begin
    a <= $shortrealtobits(a_real);
    b <= $shortrealtobits(b_real);
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
    AddSingle(1.5, 1.5);
    AddSingle(-1.5, -1.5);
    AddSingle(1.5e-3, 1.5);
    AddSingle(2.0, -1.5);
    AddSingle(1.5, 0.15);
    AddSingle(1.5, 0.75);
    AddSingle(1.765e10, 1.875e-10);
    AddSingle(1.5, -1.5);
    AddSingle(150.0, -175.0);
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

single_add_1clk single_add_1clk1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(b),
.out_valid(out_valid),
.c(c)
);
    
endmodule
