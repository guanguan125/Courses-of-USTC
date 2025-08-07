`timescale 10ns/1ns
module FGPA_EXP_tem_tb();	
	reg sys_clk,sys_rst_n; 
	wire [7:0]dout; 
	wire [6:0]out7;
	wire dq;
	initial begin
	#0 sys_rst_n=1'b0;#2 sys_rst_n=1'b1;#2 sys_rst_n=1'b0;#2 sys_rst_n=1'b1;
	sys_clk = 1'b0;
	end
	always begin
	forever #1  sys_clk=~sys_clk;
	end
	
	FGPA_EXP_tem U1(sys_clk,sys_rst_n,dq,dout,out7);
endmodule

