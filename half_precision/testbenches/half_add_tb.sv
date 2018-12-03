`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 08:34:02 AM
// Design Name: 
// Module Name: half_add_tb
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


module half_add_tb(
);

reg rstn;
reg clk;
reg in_valid;
reg [15:0] a;
reg [15:0] b;
wire out_valid;;
wire [15:0] c;
wire [31:0] a_single;
wire [31:0] b_single;
wire [31:0] c_single;

assign a_single = (a==0) ? 0 : {a[15],8'd127 + {3'b0,a[14:10]} - 8'd15,a[9:0],13'b0};
assign b_single = (b==0) ? 0 : {b[15],8'd127 + {3'b0,b[14:10]} - 8'd15,b[9:0],13'b0};
assign c_single = (c==0) ? 0 : {c[15],8'd127 + {3'b0,c[14:10]} - 8'd15,c[9:0],13'b0};

reg [31:0] a_single2;
reg [31:0] b_single2;
reg [4:0] a_exp;
reg [4:0] b_exp;
    
task AddHalf;
  input real a_real;
  input real b_real;
  begin
    a_single2 = $shortrealtobits(a_real);
    b_single2 = $shortrealtobits(b_real);
    a_exp = a_single2[30:23] - 127 + 15;
    b_exp = b_single2[30:23] - 127 + 15;
    a <= (a_single2==0) ? 0 : {a_single2[31],a_exp,a_single2[22:13]};
    b <= (b_single2==0) ? 0 : {b_single2[31],b_exp,b_single2[22:13]};
    @(posedge clk);
  end
endtask
    
initial
  begin
    rstn <= 1;
    in_valid <= 0;
    a <= 0;
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 0;
    @(posedge clk);
    @(posedge clk);
    rstn <= 1;
    @(posedge clk);
    @(posedge clk);
    a <= 0;
    b <= 0;
    @(posedge clk);
    in_valid <= 1;
    AddHalf(1.5, 1.5);
    AddHalf(-1.5, -1.5);
    AddHalf(1.5e-2, 1.5);
    AddHalf(2.0, -1.5);
    AddHalf(1.5, 0.15);
    AddHalf(1.5, 0.75);
    AddHalf(1.765e3, 1.875e-3);
    AddHalf(1.5, -1.5);
    AddHalf(150.0, -175.0);
    a <= 0;
    b <= 0;
    in_valid <= 0;
    @(posedge clk);
    a <= 16'h8000;
    b <= 16'h0000;
    @(posedge clk);
    a <= 16'h0000;
    b <= 16'h8000;
    @(posedge clk); 
    a <= 0;
    b <= 0;
    @(posedge clk);
    @(posedge clk);
    $stop;
  end    
    
initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

half_add half_add1(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(b),
.out_valid(out_valid),
.c(c)
);

endmodule
