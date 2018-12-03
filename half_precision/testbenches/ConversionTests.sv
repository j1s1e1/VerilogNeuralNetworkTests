`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2018 12:45:27 AM
// Design Name: 
// Module Name: ConversionTests
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


module ConversionTests();

`include "half_conversions.h"

real a;
reg [15:0] a_as_half;
reg [31:0] a_as_half_to_single;

task CalculateHalf;
  input real x;
  begin
    a_as_half = RealToHalf(x);
    a_as_half_to_single = SingleFromHalf(a_as_half);
    #10;
  end
endtask

initial
  begin
    CalculateHalf(1.0);
    CalculateHalf(2.0);
    CalculateHalf(4e-5);
    CalculateHalf(6.01e-6);
    CalculateHalf(1.0e5);
    CalculateHalf(1.0e10);
    CalculateHalf(1.0e15);
    CalculateHalf(1.0);
    CalculateHalf(-1.0);
    CalculateHalf(-2.0);
    CalculateHalf(-4e-5);
    CalculateHalf(-6.01e-6);
    CalculateHalf(-1.0e5);
    CalculateHalf(-1.0e10);
    CalculateHalf(-1.0e15);
    CalculateHalf(-1.0);   
    $stop;
  end
endmodule
