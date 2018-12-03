`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 03:12:17 AM
// Design Name: 
// Module Name: single_softmax_v_tb
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


module single_softmax_v_tb(
);

parameter WIDTH = 10;

reg rstn;
reg clk;
reg start;
reg [31:0] vector_a[WIDTH];
wire done;
wire [31:0] vector_c[WIDTH];

task SendVector;
  input real d0;
  input real d1;
  input real d2;
  input real d3;
  input real d4;
  input real d5;
  input real d6;
  input real d7;
  input real d8;
  input real d9;
  begin
    vector_a <= {{$shortrealtobits(d0)}, {$shortrealtobits(d1)}, {$shortrealtobits(d2)}, {$shortrealtobits(d3)},
                 {$shortrealtobits(d4)}, {$shortrealtobits(d5)}, {$shortrealtobits(d6)}, {$shortrealtobits(d7)},
                 {$shortrealtobits(d8)}, {$shortrealtobits(d9)}};
  end
endtask

initial
  begin
    rstn <= 1;
    start <= 0;
    vector_a <= {default : 0};
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    repeat (10) @(posedge clk);                  
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    start <= 1;
    SendVector(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0);
    @(posedge clk);
    start <= 0;
    vector_a <= {default : 0};
    @(posedge clk);
    repeat (150) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

single_softmax_v #(.WIDTH(WIDTH))
single_softmax_v1
(
.rstn(rstn),
.clk(clk),
.start(start),
.vector_a(vector_a),
.done(done),
.vector_c(vector_c)
);

endmodule
