`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 02:13:50 AM
// Design Name: 
// Module Name: single_dot_v_m_tb
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


module single_dot_v_m_tb(
);

parameter WIDTH = 5;
parameter HEIGHT = 5;

reg rstn;
reg clk;
reg start;
reg [31:0] vector[WIDTH];
reg [31:0] matrix[WIDTH][HEIGHT];
wire done;
wire [31:0] vector_out[HEIGHT];

task SetVector;
  input real data0;
  input real data1;
  input real data2;
  input real data3;
  input real data4;
  begin
    vector = {{$shortrealtobits(data0)}, {$shortrealtobits(data1)},
              {$shortrealtobits(data2)}, {$shortrealtobits(data3)},
              {$shortrealtobits(data4)}};
  end
endtask

task SetMatrixRow;
  input integer row;
  input real data0;
  input real data1;
  input real data2;
  input real data3;
  input real data4;  
  begin
    matrix[row][0] = $shortrealtobits(data0);
    matrix[row][1] = $shortrealtobits(data1);
    matrix[row][2] = $shortrealtobits(data2);
    matrix[row][3] = $shortrealtobits(data3);
    matrix[row][4] = $shortrealtobits(data4);
  end
endtask

task SetMatrix;
  input real r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, 
             r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, 
             r20, r21, r22, r23, r24;
  begin
  SetMatrixRow(0, r0, r1, r2, r3, r4);
  SetMatrixRow(1, r5, r6, r7, r8, r9);
  SetMatrixRow(2, r10, r11, r12, r13, r14);
  SetMatrixRow(3, r15, r16, r17, r18, r19);
  SetMatrixRow(4, r20, r21, r22, r23, r24);
  end
endtask

initial
  begin
    rstn <= 1;
    start <= 0;
    vector <= {default : 0};
    matrix <= {default : 0};
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    start <= 1;
    SetVector( 1.0, 2.0, 3.0, 4.0, 5.0 );
    SetMatrix( 1.0, 2.0, 3.0, 4.0, 5.0,
               1.0, 2.0, 3.0, 4.0, 5.0,
               1.0, 2.0, 3.0, 4.0, 5.0,
               1.0, 2.0, 3.0, 4.0, 5.0,
               1.0, 2.0, 3.0, 4.0, 5.0
              );
    
    @(posedge clk);
    start <= 0;
    @(posedge clk);
    @(posedge clk);
    repeat (10) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

single_dot_v_m #(.WIDTH(WIDTH), .HEIGHT(HEIGHT))
single_dot_v_m1
(
.rstn(rstn),
.clk(clk),
.start(start),
.vector(vector),
.matrix(matrix),
.done(done),
.vector_out(vector_out)
);

endmodule
