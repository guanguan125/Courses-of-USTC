module Div50MHz(clk,clkout);//模拟分频信号
	input clk;
	output clkout;
	reg clkout;
	integer cnt;
		always @ (posedge clk)
			begin
				if (cnt==4999)
					begin
						cnt<=0;
						clkout<=~clkout;
					end
				else cnt<=cnt+1;
				
			end
endmodule
//############
module Counter8(clk,q);//由时间触发，进行从0-7计数
	input clk;
	output [2:0]q;
	reg [2:0]tmp_q;
		
		assign q=tmp_q;
		always @ (posedge clk)
			begin
				if(tmp_q==3'b111)
					tmp_q<=3'b000;
				else
					tmp_q<=tmp_q+1;
			end
endmodule
//############
module Decoder38(din,dout);//3-8译码器，完成3位2进制到8个数码管的选择
	input [2:0]din;
	output [7:0]dout;
	reg [7:0]dout;
	
		always @ (din)
			case (din)
				3'b000:dout=8'b00000001;
				3'b001:dout=8'b00000010;
				3'b010:dout=8'b00000100;
				3'b011:dout=8'b00001000;
				3'b100:dout=8'b00010000;
				3'b101:dout=8'b00100000;
				3'b110:dout=8'b01000000;
				3'b111:dout=8'b10000000;
				default:dout=8'b00000000;
			endcase
endmodule
//############
module latch4(en,data4,cs,dataout4);//一个锁存器
	input en;
	input [3:0]data4;
	input cs;
	output [3:0]dataout4;
	reg [3:0]dataout4;
		always @ (en,data4,cs)
			begin
				if (cs==1)
				begin
					if (en==1)
					begin
						dataout4<=data4;
					end
				end
			end
endmodule
//############
module Decide1From8(D0,D1,D2,D3,D4,D5,D6,D7,Out,din);//8选1模块
	input [3:0]D0,D1,D2,D3,D4,D5,D6,D7;
	input [2:0]din;
	output [3:0]Out;
	reg [3:0]Out;
		always @ (D0,D1,D2,D3,D4,D5,D6,D7)
			begin
				case (din)
					3'b000:Out=D0;
					3'b001:Out=D1;
					3'b010:Out=D2;
					3'b011:Out=D3;
					3'b100:Out=D4;
					3'b101:Out=D5;
					3'b110:Out=D6;
					3'b111:Out=D7;
					default:Out=D0;
				endcase
			end
endmodule
//############
module Decoder47(in4,out7);//4-7译码器
	input [3:0]in4;
	output [6:0]out7;
	reg [6:0]out7;
		always @ (in4)
			begin
				case (in4)
					3'b0000:out7=7'b0000001;
					3'b0001:out7=7'b1001111;
					3'b0010:out7=7'b0010010;
					3'b0011:out7=7'b0000110;
					3'b0100:out7=7'b1001100;//4
					3'b0101:out7=7'b0100100;
					3'b0110:out7=7'b0100000;
					3'b0111:out7=7'b0001111;//7
					default:out7=7'b0000000;
				endcase
			end
endmodule
//out7对应ABCDEFG，dout对应数码管阳极，en是使能信号，clk时钟信号，data4数字信号，cs片选信号
module FPGA_EXP2_fhr(clk,dout,en,data4,cs,out7);//clk是时钟，经过U1后变成了400Hz；dout是3-8译码器的输出；U2得到的mq是计数器
	input clk,en;
	input [3:0]data4;
	input [2:0]cs;
	output [7:0]dout;
	output [6:0]out7;
	wire clklhz;
	wire [2:0]mq;
	wire [7:0]csout;
	wire [3:0]dout0,dout1,dout2,dout3,dout4,dout5,dout6,dout7,out1;
		Div50MHz U1(clk,clklhz);//这三个语句完成了从分频器到译码器的操作
		Counter8 U2(clklhz,mq);
		
		Decoder38 U3(mq,dout);
		
		latch4 U4(en,data4,csout[0],dout0);
		latch4 U5(en,data4,csout[1],dout1);
		latch4 U6(en,data4,csout[2],dout2);
		latch4 U7(en,data4,csout[3],dout3);
		latch4 U8(en,data4,csout[4],dout4);
		latch4 U9(en,data4,csout[5],dout5);
		latch4 U10(en,data4,csout[6],dout6);
		latch4 U11(en,data4,csout[7],dout7);
		
		Decide1From8 U12(dout0,dout1,dout2,dout3,dout4,dout5,dout6,dout7,out1,mq);
		
		Decoder47 U13(out1,out7);
		
		Decoder38 U14(cs,csout);
		
endmodule