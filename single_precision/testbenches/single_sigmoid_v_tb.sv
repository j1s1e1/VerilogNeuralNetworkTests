`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 04:39:27 AM
// Design Name: 
// Module Name: single_sigmoid_v_tb
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


module single_sigmoid_v_tb(
);

parameter WIDTH = 5;

reg rstn;
reg clk;
reg in_valid;
reg [31:0] vector_a[WIDTH];
wire out_valid;
wire [31:0] vector_c[WIDTH];

task SendData;
  input real d0;
  input real d1;
  input real d2;
  input real d3;
  input real d4;
  begin
    vector_a <= {{$shortrealtobits(d0)}, {$shortrealtobits(d1)}, {$shortrealtobits(d2)},
                 {$shortrealtobits(d3)}, {$shortrealtobits(d4)}};
    in_valid <= 1;
    @(posedge clk);
    in_valid <= 0;
    vector_a <= {default : 0};
    @(posedge clk);
  end  
endtask

initial
  begin
    rstn <= 1;
    in_valid <= 0;
    vector_a <= {default : 0};
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    SendData(1.0, 2.0, 3.0, 4.0, 5.0);
    @(posedge clk);                  
    @(posedge clk);
    @(posedge clk);
    repeat (250) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

single_sigmoid_v #(.WIDTH(WIDTH))
single_sigmoid_v1
(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.vector_a(vector_a),
.out_valid(out_valid),
.vector_c(vector_c)
);

endmodule
