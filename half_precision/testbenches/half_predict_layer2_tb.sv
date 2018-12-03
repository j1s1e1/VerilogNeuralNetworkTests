`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 03:11:36 PM
// Design Name: 
// Module Name: half_predict_layer2_tb
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


module half_predict_layer2_tb(
);

`include "half_conversions.h"

parameter LAYER2_NEURONS = 50;
parameter OUTPUT_NODES = 10;

`define SEEK_SET 0
`define SEEK_CUR 1
`define SEEK_END 2

reg rstn;
reg clk;
reg start;
reg [15:0] l[LAYER2_NEURONS];
reg [15:0] W2[LAYER2_NEURONS][OUTPUT_NODES];
reg [15:0] b2[OUTPUT_NODES];
wire done;
wire [15:0] y[OUTPUT_NODES];

reg [7:0] memory[0:400000];
integer fileId;
integer imageLayer1OutputFileId;
reg [63:0] imageLayer1Output_doubles[50];
reg [15:0] imageLayer1Output_halves[50];

wire [31:0] y_singles[OUTPUT_NODES];

generate
  genvar g;
  for (g = 0 ; g < OUTPUT_NODES; g = g + 1)
    assign y_singles[g] = SingleFromHalf(y[g]);
endgenerate


task ReadFile;
  begin
    fileId = $fopen("../../MNIST/mnist_network.bin", "rb");
    $fread(memory, fileId);
    $fclose(fileId);
  end
endtask

task OpenImageLayer1OutputFile;
  begin
    imageLayer1OutputFileId = $fopen("../../MNIST/Layer1Output.bin", "rb");
  end
endtask

task CloseImageLayer1OutputFile;
  $fclose(imageLayer1OutputFileId);
endtask

task LoadW2;
  integer offset;
  integer i;
  integer j;
  reg [63:0] data_bits;
  real data;
  reg [31:0] data_short;
  begin
    offset = 326356;
    for (i = 0; i < 50; i = i + 1)
      begin
        for (j = 0; j < 10; j = j + 1)
          begin
            data_bits = {memory[offset+7],memory[offset+6],memory[offset+5],memory[offset+4],
                    memory[offset+3],memory[offset+2],memory[offset+1],memory[offset]};
            data = $bitstoreal(data_bits);
            W2[i][j] = RealToHalf(data);
            offset = offset + 8;
          end
        offset = offset + 10;
      end
  end
endtask

task Loadb2;
  integer offset;
  integer i;
  reg [63:0] data_bits;
  real data;
  begin
    offset = 4826;
    for (i = 0; i < 10; i = i + 1)
      begin
        data_bits = {memory[offset+7],memory[offset+6],memory[offset+5],memory[offset+4],
                memory[offset+3],memory[offset+2],memory[offset+1],memory[offset]};
        data = $bitstoreal(data_bits);
        b2[i] = RealToHalf(data); 
        offset = offset + 8;
      end
  end
endtask

task LoadImageLayer1Output;
  input integer image;
  integer offset;
  integer r;
  integer i;
  begin
    offset = 8 * 50 * image;
    r = $fseek(imageLayer1OutputFileId, offset, `SEEK_SET);
    $fread(imageLayer1Output_doubles, imageLayer1OutputFileId);
    for (i = 0; i < 50; i = i + 1)
      begin
        imageLayer1Output_doubles[i][7:0] <= imageLayer1Output_doubles[i][63:56];
        imageLayer1Output_doubles[i][15:8] <= imageLayer1Output_doubles[i][55:48];
        imageLayer1Output_doubles[i][23:16] <= imageLayer1Output_doubles[i][47:40];
        imageLayer1Output_doubles[i][31:24] <= imageLayer1Output_doubles[i][39:32];
        imageLayer1Output_doubles[i][39:32] <= imageLayer1Output_doubles[i][31:24];
        imageLayer1Output_doubles[i][47:40] <= imageLayer1Output_doubles[i][23:16];
        imageLayer1Output_doubles[i][55:48] <= imageLayer1Output_doubles[i][15:8];
        imageLayer1Output_doubles[i][63:56] <= imageLayer1Output_doubles[i][7:0];
      end
    @(posedge clk);
  end
endtask

task CreateHalves;
  integer i;
  real divisor;
  real data[784];
  begin
    divisor = 255.0;
    for (i = 0; i < 50; i = i + 1)
      begin
        data[i] = $bitstoreal(imageLayer1Output_doubles[i]);
        imageLayer1Output_halves[i] = RealToHalf(data[i]);
      end
  end
endtask

task SendImageLayer1Output;
  input integer i;
  begin
    LoadImageLayer1Output(i);
    CreateHalves();
    l <= imageLayer1Output_halves;
    start <= 1;
    @(posedge clk);
    start <= 0;
    @(posedge clk);
  end
endtask

initial
  begin
    rstn <= 1;
    start <= 0;
    l <= {default : 0};
    W2 <= {default : 0};
    b2 <= {default : 0};
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    repeat (10) @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    ReadFile();
    LoadW2();
    Loadb2();
    OpenImageLayer1OutputFile();
    @(posedge clk);
    SendImageLayer1Output(0);
    @(posedge clk);
    repeat (200) @(posedge clk);
    CloseImageLayer1OutputFile();
    @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end


half_predict_layer2 #(.LAYER2_NEURONS(LAYER2_NEURONS), .OUTPUT_NODES(OUTPUT_NODES))
half_predict_layer2_1
(
.rstn(rstn),
.clk(clk),
.start(start),
.l(l),
.W2(W2),
.b2(b2),
.done(done),
.y(y)
);

endmodule
