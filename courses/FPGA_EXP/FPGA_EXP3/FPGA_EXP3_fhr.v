module FSM1(clk,reset,mealy);
	input clk,reset;
	output mealy;
	reg mealy;
	parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9;
	reg [3:0]st;
		always @(posedge clk or negedge reset)begin
			if(!reset)begin
				st<=S0;
			end
			else begin
				case(st)
				S0:begin st<=S1;
				end
				S1:begin st<=S2;
				end
				S2:begin st<=S3;
				end
				S3:begin st<=S4;
				end
				S4:begin st<=S5;
				end
				S5:begin st<=S6;
				end
				S6:begin st<=S7;
				end
				S7:begin st<=S8;
				end
				S8:begin st<=S9;
				end
				S9:begin st<=S0;
				end
				endcase
			end
		end 
		always @(st)begin
		if((st==S0)||(st==S1)||(st==S2)||(st==S4)||(st==S7)||(st==S8))begin
			mealy<=1;
		end
		else begin
			mealy<=0;
		end
		end
endmodule

module FSM2(clk,reset,mealy);
	input clk,reset;
	output mealy;
	reg mealy;
	parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9;
	reg [3:0]st;
		always @(posedge clk or negedge reset)begin
			if(!reset)begin
				st<=S0;
			end
			else begin
				case(st)
				S0:begin st<=S1;
				end
				S1:begin st<=S2;
				end
				S2:begin st<=S3;
				end
				S3:begin st<=S4;
				end
				S4:begin st<=S5;
				end
				S5:begin st<=S6;
				end
				S6:begin st<=S7;
				end
				S7:begin st<=S8;
				end
				S8:begin st<=S9;
				end
				S9:begin st<=S0;
				end
				endcase
			end
		end 
		always @(st)begin
		if((st==S0))begin
			mealy<=1;
		end
		else begin
			mealy<=0;
		end
		end
endmodule
module FSM3(clk,reset,D,mealy,st);
	input D,reset,clk;
	output mealy;
	reg mealy;
	output [3:0]st;
	reg [3:0]st;
	
	parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9;
	
		always @(posedge clk or negedge reset)begin
			if(!reset)begin
				st<=S0;
			end
			else begin
				case(st)
				S0:begin if(D==0)st<=S0;
				else st<=S1;
				end
				S1:begin if(D==0)st<=S0;
				else st<=S2;
				end
				S2:begin if(D==0)st<=S0;
				else st<=S3;
				end
				S3:begin if(D==0)st<=S4;
				else st<=S3;
				end
				S4:begin if(D==0)st<=S0;
				else st<=S5;
				end
				S5:begin if(D==0)st<=S6;
				else st<=S2;
				end
				S6:begin if(D==0)st<=S7;
				else st<=S1;
				end
				S7:begin if(D==0)st<=S0;
				else st<=S8;
				end
				S8:begin if(D==0)st<=S0;
				else st<=S9;
				end
				S9:begin if(D==0)st<=S0;
				else st<=S1;
				end
				endcase
			end
		end 
		
		
		always @(st)begin
		if(st==S9)begin
			mealy<=1;
		end
		else begin
			mealy<=0;
		end
		end
endmodule

module decide_1_from_2(dout1,dout2,D,decide);
	input dout1,dout2,decide;
	output D;
	reg D;
		always @ (dout1,dout2,D)
			begin
			if (decide)begin
				D<=dout1;
			end
			else begin
				D<=dout2;
			end
			end
endmodule

module Div50MHz(clk,clkout,res);//模拟分频信号 
	input clk,res; 
	output clkout; 
	reg clkout; 
	integer cnt; 
	always @ (posedge clk or negedge res) 
	begin 
	if (!res)begin
		cnt<=0; 
		clkout<=0;
	end
	else begin
	if (cnt==49999999) begin 
	cnt<=0; 
	clkout<=~clkout; 
	end 
	else cnt<=cnt+1; 
	end 
	end
endmodule 


//clk时钟 rst_n重置 decide二选一
module FPGA_EXP3_fhr(clk,rst_n,decide,out,D,st);
	input clk,rst_n,decide;
	output out,D;
	output [3:0]st;
	wire dout1,dout2;
		Div50MHz U1(clk,clkout,rst_n);
		FSM1 U2(clkout,rst_n,dout1);
		FSM2 U3(clkout,rst_n,dout2);
		decide_1_from_2 U4(dout1,dout2,D,decide);
		FSM3 U5(clkout,rst_n,D,out,st);
endmodule