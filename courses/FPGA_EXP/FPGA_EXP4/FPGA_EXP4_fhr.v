module Div50MHz(clk,clkout,res);//模拟分频信号  
	input clk,res;  
	output clkout;  
	reg clkout;  
	integer cnt;  
	always @ (posedge clk or negedge res)  begin  
		if (!res)begin 
			cnt<=0;  
			clkout<=0; 
			end 
		else begin 
			if (cnt==999) begin  //5*10^7/5*10^4=1000Hz
			cnt<=0;  
			clkout<=~clkout;  
			end  
			else cnt<=cnt+1;  
		end  
	end 
endmodule  

module Counter0to3(clk,counter0to3,res);//由时间触发，进行从 0-3 计数
	input clk,res;
	output [1:0]counter0to3;
	
	reg [1:0]tmp_q;
	
	assign counter0to3=tmp_q;
	always @ (posedge clk or negedge res)
	begin
		if (!res)begin
			tmp_q=2'b00;end
		else begin
		if(tmp_q==2'b11)begin
			tmp_q<=2'b00;end
		else begin
			tmp_q<=tmp_q+1;end
			end
	end
endmodule

module CodeScanner(counter0to3,out);
	input [1:0]counter0to3;
	output [3:0]out;
	reg [3:0]tmp_out;
	assign out=tmp_out;
		always @ (counter0to3)begin
			case(counter0to3)
				2'b00:tmp_out<=4'b1110;
				2'b01:tmp_out<=4'b1101;
				2'b10:tmp_out<=4'b1011;
				2'b11:tmp_out<=4'b0111;
				default:tmp_out<=4'b1111;
			endcase
		end
endmodule

module Reader(SW_R,code,counter0to3,clk);//clk
	input [3:0]SW_R;
	input clk;
	input [1:0]counter0to3;
	output [4:0]code;
	reg [4:0]tmp_code;
	assign code=tmp_code;
	always @ (posedge clk)begin//posedge clk
		if (counter0to3==2'b00)begin
			case(SW_R)
				4'b1110:tmp_code<=5'b10000;
				4'b1101:tmp_code<=5'b10001;
				4'b1011:tmp_code<=5'b10010;
				4'b0111:tmp_code<=5'b10011;
				default:tmp_code<=5'b00000;
			endcase
		end
		
		if (counter0to3==2'b01)begin
			case(SW_R)
				4'b1110:tmp_code<=5'b10100;
				4'b1101:tmp_code<=5'b10101;
				4'b1011:tmp_code<=5'b10110;
				4'b0111:tmp_code<=5'b10111;
				default:tmp_code<=5'b00000;
			endcase
		end
		
		if (counter0to3==2'b10)begin
			case(SW_R)
				4'b1110:tmp_code<=5'b11000;
				4'b1101:tmp_code<=5'b11001;
				4'b1011:tmp_code<=5'b11010;
				4'b0111:tmp_code<=5'b11011;
				default:tmp_code<=5'b00000;
			endcase
		end
		
		if (counter0to3==2'b11)begin
			case(SW_R)
				4'b1110:tmp_code<=5'b11100;
				4'b1101:tmp_code<=5'b11101;
				4'b1011:tmp_code<=5'b11110;
				4'b0111:tmp_code<=5'b11111;
				default:tmp_code<=5'b00000;
			endcase
		end
	end
endmodule

module Decoder47(code,out7,res,out1);//4-7 译码器
	input [4:0]code;
	input res;
	output [6:0]out7;
	output out1;
	reg out1;
	reg [6:0]out7;
	always @ (code,res)begin
		if (res==1)out1=1;
		else out1=0;
		case (code)
			5'b10000:out7<=7'b1001111;
			5'b10001:out7<=7'b1001100;
			5'b10010:out7<=7'b0001111;
			5'b10011:out7<=7'b0110000;
			5'b10100:out7<=7'b0010010;//4
			5'b10101:out7<=7'b0100100;
			5'b10110:out7<=7'b0000000;
			5'b10111:out7<=7'b0000001;//7
			5'b11000:out7<=7'b0000110;//8
			5'b11001:out7<=7'b0100000;//9
			5'b11010:out7<=7'b0000100;//10
			5'b11011:out7<=7'b0111000;//11
			5'b11100:out7<=7'b0001000;//12
			5'b11101:out7<=7'b1100000;//13
			5'b11110:out7<=7'b0110001;//14
			5'b11111:out7<=7'b1000010;//15
			default:out7<=out7;
		endcase
	end
endmodule

module FPGA_EXP4(SW_R,clk,res,SW_C,out7,out1);//
	input clk,res;//
	input [3:0]SW_R;
	output [6:0]out7;
	output [3:0]SW_C;
	output out1;
	wire clkout;
	wire [1:0]counter0to3;
	wire [4:0]code;
	Div50MHz U1(clk,clkout,res);
	Counter0to3 U2(clkout,counter0to3,res);//q为0-3的计数
	CodeScanner U3(counter0to3,SW_C);
	Reader U4(SW_R,code,counter0to3,clkout);
	Decoder47 U5(code,out7,res,out1);
endmodule
