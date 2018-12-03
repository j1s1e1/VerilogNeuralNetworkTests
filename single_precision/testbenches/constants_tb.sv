`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 02:04:22 AM
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

initial
  begin
    $display("%x", $shortrealtobits(-0.5));
    $display("%x", $shortrealtobits(0.5));
    
    $display("%x", $shortrealtobits(2.33184211722314911771e2));
    $display("%x", $shortrealtobits(4.36821166879210612817e3));
    
    $display("%x", $shortrealtobits(2.30933477057345225087e-2));
    $display("%x", $shortrealtobits(2.02020656693165307700e1));
    $display("%x", $shortrealtobits(1.51390680115615096133e3));
    $display("%x", $shortrealtobits(2.0));
    $display("%x", $shortrealtobits(1.0));
    
    $stop;
  end

endmodule
