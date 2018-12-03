`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 04:52:42 PM
// Design Name: 
// Module Name: half_predict_layer1_tb
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


module half_predict_layer1_tb(
);

`include "half_conversions.h"

parameter LAYER1_NEURONS = 784;
parameter LAYER2_NEURONS = 50;

`define SEEK_SET 0
`define SEEK_CUR 1
`define SEEK_END 2

reg rstn;
reg clk;
reg start;
reg [15:0] x[LAYER1_NEURONS];
reg [15:0] W1[LAYER1_NEURONS][LAYER2_NEURONS];
reg [15:0] b1[LAYER2_NEURONS];
wire done;
wire [15:0] l[LAYER2_NEURONS];

reg [7:0] memory[0:76815];
integer fileId;
integer imageFileId;
reg [7:0] image_bytes[784];
reg [15:0] image_halves[784];

wire [31:0] l_singles[LAYER2_NEURONS];

generate
  genvar g;
  for (g = 0 ; g < LAYER2_NEURONS; g = g + 1)
    assign l_singles[g] = SingleFromHalf(l[g]);
endgenerate

task ReadFile;
  integer r;
  begin
    fileId = $fopen("../../MNIST/mnist_network.bin", "rb");
    r = $fread(memory, fileId);
    $fclose(fileId);
  end
endtask

task OpenImageFile;
  begin
    imageFileId = $fopen("../../MNIST/t100-images.idx3-ubyte", "rb");
  end
endtask

task CloseImageFile;
  $fclose(imageFileId);
endtask

task LoadW1;
  integer offset;
  integer i;
  integer j;
  reg [63:0] data_bits;
  real data;
  begin
    offset = 4916;
    for (i = 0; i < 784; i = i + 1)
      begin
        for (j = 0; j < 50; j = j + 1)
          begin
            data_bits = {memory[offset+7],memory[offset+6],memory[offset+5],memory[offset+4],
                    memory[offset+3],memory[offset+2],memory[offset+1],memory[offset]};
            data = $bitstoreal(data_bits);
            W1[i][j] = RealToHalf(data);
            offset = offset + 8;
          end
        offset = offset + 10;
      end
  end
endtask

task Loadb1;
  integer offset;
  integer i;
  reg [63:0] data_bits;
  real data;
  begin
    offset = 4416;
    for (i = 0; i < 50; i = i + 1)
      begin
        data_bits = {memory[offset+7],memory[offset+6],memory[offset+5],memory[offset+4],
                memory[offset+3],memory[offset+2],memory[offset+1],memory[offset]};
        data = $bitstoreal(data_bits);
        b1[i] = RealToHalf(data); 
        offset = offset + 8;
      end
  end
endtask

task LoadImage;
  input integer image;
  integer offset;
  integer r;
  begin
    offset = 16 + 28 * 28 * image;
    r = $fseek(fileId, offset, `SEEK_SET);
    r = $fread(image_bytes, fileId);
  end
endtask

task CreateHalves;
  integer i;
  real divisor;
  real data[784];
  begin
    divisor = 255.0;
    for (i = 0; i < 784; i = i + 1)
      begin
        data[i] = $itor(image_bytes[i]);
        data[i] = data[i] / divisor;
        image_halves[i] = RealToHalf(data[i]);
      end
  end
endtask

task SendImage;
  input integer i;
  begin
    LoadImage(i);
    CreateHalves();
    x <= image_halves;
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
    x <= {default : 0};
    W1 <= {default : 0};
    b1 <= {default : 0};
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    repeat (10) @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    ReadFile();
    LoadW1();
    Loadb1();
    OpenImageFile();
    @(posedge clk);
    SendImage(0);
    @(posedge clk);
    CloseImageFile();
    repeat (100) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end


half_predict_layer1 #(.LAYER1_NEURONS(LAYER1_NEURONS), .LAYER2_NEURONS(LAYER2_NEURONS))
half_predict_layer1_1
(
.rstn(rstn),
.clk(clk),
.start(start),
.x(x),
.W1(W1),
.b1(b1),
.done(done),
.l(l)
);

endmodule
