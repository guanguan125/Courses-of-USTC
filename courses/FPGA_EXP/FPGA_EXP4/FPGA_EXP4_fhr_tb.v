`timescale 10ns/1ns
module FPGA_EXP4_fhr_tb();
	reg clk,res;
	reg [3:0]SW_R;
	wire out1;
	wire [6:0]out7;
	wire [3:0]SW_C;
	always begin
	#0 res=0;#2 res=1;
	#2 res=0;#2 res=1;
	#2 SW_R=4'b0111;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#0 SW_R=4'b1111;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	#1 clk=0;#1 clk=1;
	end
	
	FPGA_EXP4 U1(SW_R,clk,res,SW_C,out7,out1);
endmodule
//module FPGA_EXP4(SW_R,clk,res,SW_C,out7,out1);//