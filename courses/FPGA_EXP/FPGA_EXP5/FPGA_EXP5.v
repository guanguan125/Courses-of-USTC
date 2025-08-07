module Counter0to3(clk,address,res);//由时间触发，进行从 0-3 计数
	input clk,res;
	output [9:0]address;
	
	reg [9:0]tmp_q;
	
	assign address=tmp_q;
	always @ (posedge clk or negedge res)
	begin
		if (!res)begin
			tmp_q=10'b0000000000;end
		else begin
		if(tmp_q==10'b1111111111)begin
			tmp_q<=10'b0000000000;end
		else begin
			tmp_q<=tmp_q+1;end
			end
	end
endmodule

module FPGA_EXP5(res,clk,sin_data);
	input res,clk;
	output [7:0]sin_data;
	wire [9:0]address;
	
			Counter0to3 U1(clk,address,res);
			mystorage U2(address,clk,sin_data);
endmodule