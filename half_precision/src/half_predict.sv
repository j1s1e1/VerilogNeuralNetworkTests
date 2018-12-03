`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 02:46:49 PM
// Design Name: 
// Module Name: half_predict
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


module half_predict
#(
parameter LAYER1_NEURONS = 10,
parameter LAYER2_NEURONS = 10,
parameter OUTPUT_NODES = 10
)
(
input rstn,
input clk,
input start,
input [15:0] x[LAYER1_NEURONS],
input [15:0] W1[LAYER1_NEURONS][LAYER2_NEURONS],
input [15:0] b1[LAYER2_NEURONS],
input [15:0] W2[LAYER2_NEURONS][OUTPUT_NODES],
input [15:0] b2[OUTPUT_NODES],
output done,
output [15:0] y[OUTPUT_NODES]
);

wire [15:0] l[LAYER2_NEURONS];
wire done_layer1;
reg done_layer1_d;
reg start_layer2;

always @(posedge clk)
  if (!rstn)
    done_layer1_d <= 0;
  else
    done_layer1_d <= done_layer1;
    
always @(posedge clk)
  if (!rstn)
    start_layer2 <= 0;
  else
    if (done_layer1 & !done_layer1_d)
      start_layer2 <= 1;
    else
      start_layer2 <= 0; 
  
  

half_predict_layer1 #(.LAYER1_NEURONS(LAYER1_NEURONS), .LAYER2_NEURONS(LAYER2_NEURONS))
half_predict_layer1_1
(
.rstn(rstn),
.clk(clk),
.start(start),
.x(x),
.W1(W1),
.b1(b1),
.done(done_layer1),
.l(l)
);

half_predict_layer2 #(.LAYER2_NEURONS(LAYER2_NEURONS), .OUTPUT_NODES(OUTPUT_NODES))
half_predict_layer2_1
(
.rstn(rstn),
.clk(clk),
.start(start_layer2),
.l(l),
.W2(W2),
.b2(b2),
.done(done),
.y(y)
);

endmodule
