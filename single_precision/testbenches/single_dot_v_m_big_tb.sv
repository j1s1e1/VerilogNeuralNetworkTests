`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 02:20:44 AM
// Design Name: 
// Module Name: single_dot_v_m_big_tb
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


module single_dot_v_m_big_tb(
);

parameter WIDTH = 784;
parameter HEIGHT = 50;

`define SEEK_SET 0
`define SEEK_CUR 1
`define SEEK_END 2

reg rstn;
reg clk;
reg start;
reg [31:0] x[WIDTH];
reg [31:0] W1[WIDTH][HEIGHT];
wire done;
wire [31:0] l[HEIGHT];

reg [7:0] memory[0:400000];
integer fileId;
integer imageFileId;
reg [7:0] image_bytes[784];
reg [31:0] image_singles[784];

task ReadFile;
  begin
    fileId = $fopen("C:\\Users\\Jamie\\Documents\\Visual Studio 2017\\Projects\\NeuralNetwork\\NeuralNetwork\\bin\\Debug\\mnist_network.bin", "rb");
    $fread(memory, fileId);
    $fclose(fileId);
  end
endtask

task OpenImageFile;
  begin
    imageFileId = $fopen("C:\\Users\\Jamie\\Documents\\Visual Studio 2017\\Projects\\NeuralNetwork\\NeuralNetwork\\MNIST\\train-images.idx3-ubyte", "rb");
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
            W1[i][j] = $shortrealtobits(data);
            offset = offset + 8;
          end
        offset = offset + 10;
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
    $fread(image_bytes, fileId);
  end
endtask

task CreateSingles;
  integer i;
  real divisor;
  real data[784];
  begin
    divisor = 255.0;
    for (i = 0; i < 784; i = i + 1)
      begin
        data[i] = $itor(image_bytes[i]);
        data[i] = data[i] / divisor;
        image_singles[i] = $shortrealtobits(data[i]);
      end
  end
endtask

task SendImage;
  input integer i;
  begin
    LoadImage(i);
    CreateSingles();
    x <= image_singles;
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
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    ReadFile();
    LoadW1();
    OpenImageFile();    
    @(posedge clk);    
    SendImage(0);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    CloseImageFile();
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
.vector(x),
.matrix(W1),
.done(done),
.vector_out(l)
);

endmodule
