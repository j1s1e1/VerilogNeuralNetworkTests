`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:38:41 AM
// Design Name: 
// Module Name: constants_tb
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


module constants_tb(
);

reg [15:0] half_value;

task DisplayHalf;
  input real value;
  reg [31:0] a_single;
  reg [4:0] a_exp;
  reg [15:0] a;
  begin
    a_single = $shortrealtobits(value);
    a_exp = a_single[30:23] - 127 + 15;
    a = (a_single==0) ? 0 : {a_single[31],a_exp,a_single[22:13]};
    $display("%x", a);
  end
endtask

initial
  begin
    DisplayHalf(-0.5);
    DisplayHalf(0.5);
    DisplayHalf(2.33184211722314911771e2);
    DisplayHalf(4.36821166879210612817e3);
    DisplayHalf(2.30933477057345225087e-2);
    DisplayHalf(2.02020656693165307700e1);
    DisplayHalf(1.51390680115615096133e3);
    DisplayHalf(2.0);
    DisplayHalf(1.0);
    DisplayHalf(1.44269504088896);
    $stop;
  end


endmodule
