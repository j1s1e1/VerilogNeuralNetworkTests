`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 12:39:49 AM
// Design Name: 
// Module Name: single_divide_v_s_tb
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


module single_divide_v_s_tb(
);

parameter WIDTH = 4;

reg rstn;
reg clk;
reg start;
reg [31:0] vector_a[WIDTH];
reg [31:0] b;
wire done;
wire [31:0] vector_c[WIDTH];

task SetVector;
  input real d0;
  input real d1;
  input real d2;
  input real d3;
  begin
    vector_a <= {{$shortrealtobits(d0)}, {$shortrealtobits(d1)},
                 {$shortrealtobits(d2)}, {$shortrealtobits(d3)} };
  end
endtask

initial
  begin
    rstn <= 1;
    start <= 0;
    vector_a <= {default : 0};
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    start <= 1;
    SetVector(1.0, 2.0, 3.0, 4.0);
    b <= $shortrealtobits(2.0);
    @(posedge clk);
    start <= 0;
    vector_a <= {default : 0};
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    repeat (100) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

single_divide_v_s #(.WIDTH(WIDTH))
single_divide_v_s1
(
.rstn(rstn),
.clk(clk),
.start(start),
.vector_a(vector_a),
.b(b),
.done(done),
.vector_c(vector_c)
);

endmodule
