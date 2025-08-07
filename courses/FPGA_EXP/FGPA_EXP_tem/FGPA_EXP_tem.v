module  ds18b20_ctrl
(
    input   wire        sys_clk     ,   
    input   wire        sys_rst_n   ,   
    inout   wire        dq          ,   //数据总线
    output  wire [19:0] data_out    ,   //输出温度
    output  reg         sign            //输出温度符号位
);
 
parameter   S_INIT          =   3'd1, 
            S_WR_CMD        =   3'd2, 
            S_WAIT          =   3'd3, 
            S_INIT_AGAIN    =   3'd4, 
            S_RD_CMD        =   3'd5, 
            S_RD_TEMP       =   3'd6; 
 
parameter   WR_44CC_CMD =   16'h44cc; //跳过ROM及温度转换命令，低位在前
parameter   WR_BECC_CMD =   16'hbecc; //跳过ROM及读取温度命令，低位在前
 
parameter   S_WAIT_MAX  =   750000  ; //750ms
 
reg         clk_1us     ;   //分频时钟，单位时钟1us
reg [4:0]   cnt         ;   //分频计数器
reg [2:0]   state       ;   //状态机状态
reg [19:0]  cnt_1us     ;   //微秒计数器
reg [3:0]   bit_cnt     ;   //字节计数器
reg [15:0]  data_tmp    ;   //读取ds18b20的温度
reg [19:0]  data        ;   //判断完正负后的温度
reg         flag_pulse  ;   //初始化存在脉冲标志信号
reg         dq_out      ;   //输出总线数据，即FPGA给的总线数据值
reg         dq_en       ;   //输出总线数据使能信号
 
//温度转换，由于数码管位数有限，在这里保留小数点后三位
assign data_out = (data * 10'd625)/ 4'd10;

//当使能信号为1是总线的值为dq_out的值，为0时为高阻态
assign  dq  =   (dq_en ==1 ) ? dq_out : 1'bz;
 
//cnt:分频计数器
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <=  5'b0;
    else    if(cnt == 5'd24)
        cnt <=  5'b0;
    else
        cnt <=  cnt + 1'b1;
 
//clk_1us：产生单位时钟为1us的时钟
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        clk_1us <=  1'b0;
    else    if(cnt == 5'd24)
        clk_1us <=  ~clk_1us;
    else
        clk_1us <=  clk_1us;
 
//cnt_1us：1us时钟计数器，用于状态跳转
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_1us <=  20'b0;
    else    if(((state==S_WR_CMD || state==S_RD_CMD || state==S_RD_TEMP)
       && cnt_1us==20'd64) || ((state==S_INIT || state==S_INIT_AGAIN) &&
       cnt_1us==20'd999) || (state==S_WAIT && cnt_1us==S_WAIT_MAX))
        cnt_1us <=  20'b0;
    else
        cnt_1us <=  cnt_1us +   1'b1;
 
//bit_cnt：bit计数器，写1bit或读1bit加1，一次写完之后清零
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        bit_cnt  <=  4'b0;
    else    if((state == S_RD_TEMP || state == S_WR_CMD ||
         state == S_RD_CMD) && (cnt_1us == 20'd64 && bit_cnt == 4'd15))
        bit_cnt  <=  4'b0;
    else    if((state == S_WR_CMD || state == S_RD_CMD ||
                              state == S_RD_TEMP) && cnt_1us == 20'd64)
        bit_cnt  <=  bit_cnt + 1'b1;
 
//初始化存在脉冲标志信号：初始化状态时，当总线发来存在脉冲才能初始化成功
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        flag_pulse  <=  1'b0;
    else    if(cnt_1us == 20'd570 && dq == 1'b0 && (state == S_INIT ||
                                                state == S_INIT_AGAIN))
        flag_pulse  <=  1'b1;
    else    if(cnt_1us == 999)
        flag_pulse  <=  1'b0;
    else
        flag_pulse  <=  flag_pulse;
 
//状态跳转
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        state   <=  S_INIT;
    else
        case(state)
    //初始化最小时间为960us
       S_INIT:  //收到存在脉冲且时间需大于960us跳转
            if(cnt_1us == 20'd999  && flag_pulse == 1'b1 )
                state   <=  S_WR_CMD;
            else
                state   <=  S_INIT;
        S_WR_CMD:   //发送完跳过ROM和温度转换命令后跳转
            if(bit_cnt == 4'd15 && cnt_1us == 20'd64 )
                state   <=  S_WAIT;
            else
                state   <=  S_WR_CMD;
        S_WAIT: //等待750ms后跳转
            if(cnt_1us == S_WAIT_MAX)
                state   <=  S_INIT_AGAIN;
            else
                state   <=  S_WAIT;
        S_INIT_AGAIN:   //再次初始化后跳转
            if(cnt_1us == 20'd999  && flag_pulse == 1'b1 )
                state   <=  S_RD_CMD;
            else
                state   <=  S_INIT_AGAIN;
        S_RD_CMD:   //发送完跳过ROM和读取温度命令后跳转
            if(bit_cnt == 4'd15 && cnt_1us == 20'd64)
                state   <=  S_RD_TEMP;
            else
                state   <=  S_RD_CMD;
        S_RD_TEMP:  //读完2字节的温度后跳转
            if(bit_cnt == 4'd15 && cnt_1us == 20'd64)
                state   <=  S_INIT;
            else
                state   <=  S_RD_TEMP;
        default:
                state   <=  S_INIT;
        endcase
 
//给各状态下的总线相应的时序
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            dq_out  <=  1'b0;
            dq_en   <=  1'b0;
        end
    else
        case(state)
    //初始化是最小480us低电平，然后释放总线
        S_INIT:
            if(cnt_1us < 20'd499)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
    //每一个写时段最少有60us的持续时间和最少1us的恢复时间
    //写0：总线拉低后一直拉低，最少60us
    //写1：总线拉低后必须在15us内释放总线
        S_WR_CMD:
            if(cnt_1us > 20'd62)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
            else    if(cnt_1us <= 20'b1)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else    if(WR_44CC_CMD[bit_cnt] == 1'b0)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else    if(WR_44CC_CMD[bit_cnt] == 1'b1)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
    //为适应寄生电源，温度转换命令后将总线拉高
        S_WAIT:
            begin
                dq_out  <=  1'b1;
                dq_en   <=  1'b1;
            end
    //与第一次初始化时序一致
        S_INIT_AGAIN:
            if(cnt_1us < 20'd499)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
    //与发送跳过ROM和读取温度命的时序一致
        S_RD_CMD:
            if(cnt_1us > 20'd62)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
            else    if(cnt_1us <= 20'b1)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else    if(WR_BECC_CMD[bit_cnt] == 1'b0)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else    if(WR_BECC_CMD[bit_cnt] == 1'b1)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
    //拉低总线超过1us后释放总线
        S_RD_TEMP:
            if(cnt_1us <=1)
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b1;
                end
            else
                begin
                    dq_out  <=  1'b0;
                    dq_en   <=  1'b0;
                end
        default:;
        endcase
 
//data_tmp:读出温度，寄存在data_tmp里
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data_tmp    <=  12'b0;
        //总线拉低后数据有效时间为15us
    else    if(state == S_RD_TEMP && cnt_1us == 20'd13)
        data_tmp   <=  {dq,data_tmp[15:1]};
    else
        data_tmp    <=  data_tmp;
 
//温度判断，输出温度
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data    <=  20'b0;
    else    if(data_tmp[15] == 1'b0 && state == S_RD_TEMP &&
                            cnt_1us == 20'd60 && bit_cnt == 4'd15)
        data    <=  data_tmp[10:0];
    else    if(data_tmp[15] == 1'b1 && state == S_RD_TEMP &&
                            cnt_1us == 20'd60 && bit_cnt == 4'd15)
        data    <=  ~data_tmp[10:0] + 1'b1;
 
//温度判断，输出符号位
always@(posedge clk_1us or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        sign    <=  1'b0;
    else    if(data_tmp[15] == 1'b0 && state == S_RD_TEMP && cnt_1us == 20'd60 && bit_cnt == 4'd15)
        sign    <=  1'b0;
    else    if(data_tmp[15] == 1'b1 && state == S_RD_TEMP && cnt_1us == 20'd60 && bit_cnt == 4'd15)
        sign    <=  1'b1;
 
endmodule 


module Div50MHz(clk,clkout,res);//模拟分频信号
	input clk,res;
	output clkout;
	reg clkout_tmp;
	integer cnt;
	assign clkout = clkout_tmp;
		initial begin 
		clkout_tmp=0;
		cnt=0;
		end
		always @ (posedge clk)
			begin
				if (cnt==4999)
					begin
						cnt<=0;
						clkout_tmp<=~clkout_tmp;
					end
				else cnt<=cnt+1;
				
			end
endmodule


module Counter8(clk,q);//由时间触发，进行从0-7计数
	input clk;
	output [2:0]q;
	reg [2:0]tmp_q;
		
		assign q=tmp_q;
		initial begin 
			tmp_q = 3'b000;
		end
		always @ (posedge clk)
			begin
				if(tmp_q==3'b111)
					tmp_q<=3'b000;
				else
					tmp_q<=tmp_q+1;
			end
endmodule


module Decoder38(din,dout);//3-8译码器，完成3位2进制到8个数码管的选择
	input [2:0]din;
	output [7:0]dout;
	reg [7:0]dout;
	
		always @ (din)begin
			//if (din==3'b011)begin point=0;end
			//else point=1;
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
		end
endmodule



module Decoder47(in4,out7,dataout,sign);//4-7译码器
	input [3:0]in4;
	input [19:0]dataout;
	input sign;
	output [6:0]out7;
	reg [6:0]out7;
	reg [3:0]a,b,c,d,e,f;
	reg [6:0]aa,bb,cc,dd,ee,ff,gg;
		always @ (in4)
			begin
				a = dataout%10;
				b = (dataout/10)%10;
				c = (dataout/100)%10;
				d = (dataout/1000)%10;
				e = (dataout/10000)%10;
				f = (dataout/100000)%10;
				case(a)
					4'b0000:aa=7'b0000001;
					4'b0001:aa=7'b1001111;
					4'b0010:aa=7'b0010010;
					4'b0011:aa=7'b0000110;
					4'b0100:aa=7'b1001100;//4
					4'b0101:aa=7'b0100100;
					4'b0110:aa=7'b0100000;
					4'b0111:aa=7'b0001111;//7
					4'b1000:aa=7'b0000000;//8
					4'b1001:aa=7'b0000100;//9
					default:aa=7'b0000000;
				endcase
				case(b)
					4'b0000:bb=7'b0000001;
					4'b0001:bb=7'b1001111;
					4'b0010:bb=7'b0010010;
					4'b0011:bb=7'b0000110;
					4'b0100:bb=7'b1001100;//4
					4'b0101:bb=7'b0100100;
					4'b0110:bb=7'b0100000;
					4'b0111:bb=7'b0001111;//7
					4'b1000:bb=7'b0000000;//8
					4'b1001:bb=7'b0000100;//9
					default:bb=7'b0000000;
				endcase
				case(c)
					4'b0000:cc=7'b0000001;
					4'b0001:cc=7'b1001111;
					4'b0010:cc=7'b0010010;
					4'b0011:cc=7'b0000110;
					4'b0100:cc=7'b1001100;//4
					4'b0101:cc=7'b0100100;
					4'b0110:cc=7'b0100000;
					4'b0111:cc=7'b0001111;//7
					4'b1000:cc=7'b0000000;//8
					4'b1001:cc=7'b0000100;//9
					default:cc=7'b0000000;
				endcase
				case(d)
					4'b0000:dd=7'b0000001;
					4'b0001:dd=7'b1001111;
					4'b0010:dd=7'b0010010;
					4'b0011:dd=7'b0000110;
					4'b0100:dd=7'b1001100;//4
					4'b0101:dd=7'b0100100;
					4'b0110:dd=7'b0100000;
					4'b0111:dd=7'b0001111;//7
					4'b1000:dd=7'b0000000;//8
					4'b1001:dd=7'b0000100;//9
					default:dd=7'b0000000;
				endcase
				case(e)
					4'b0000:ee=7'b0000001;
					4'b0001:ee=7'b1001111;
					4'b0010:ee=7'b0010010;
					4'b0011:ee=7'b0000110;
					4'b0100:ee=7'b1001100;//4
					4'b0101:ee=7'b0100100;
					4'b0110:ee=7'b0100000;
					4'b0111:ee=7'b0001111;//7
					4'b1000:ee=7'b0000000;//8
					4'b1001:ee=7'b0000100;//9
					default:ee=7'b0000000;
				endcase
				case(f)
					4'b0000:ff=7'b0000001;
					4'b0001:ff=7'b1001111;
					4'b0010:ff=7'b0010010;
					4'b0011:ff=7'b0000110;
					4'b0100:ff=7'b1001100;//4
					4'b0101:ff=7'b0100100;
					4'b0110:ff=7'b0100000;
					4'b0111:ff=7'b0001111;//7
					4'b1000:ff=7'b0000000;//8
					4'b1001:ff=7'b0000100;//9
					default:ff=7'b0000000;
				endcase
				if (sign==1'b1)gg=7'b0000001;
				else gg=7'b1111110;
				case (in4)
					4'b0000:out7=aa;//7'b0000001;
					4'b0001:out7=bb;
					4'b0010:out7=cc;
					4'b0011:out7=dd;
					4'b0100:out7=ee;//4
					4'b0101:out7=ff;
					4'b0110:out7=gg;
					4'b0111:out7=7'b0000001;//7
					default:out7=7'b0000000;
				endcase
			end
endmodule


module FGPA_EXP_tem
(
    input   wire            sys_clk     ,  
    input   wire            sys_rst_n   ,  
    inout   wire            dq          ,  
	 output [7:0]dout,
	 output [6:0]out7
);
 
	wire    [19:0]  data_out ;
	wire            sign     ;
	wire clk_div;
	wire [2:0]mq;
	ds18b20_ctrl    U0
	(.sys_clk(sys_clk  ),.sys_rst_n(sys_rst_n),.dq(dq ),.data_out(data_out ),.sign (sign));

	Div50MHz U1(sys_clk,clk_div,sys_rst_n);
	Counter8 U2(clk_div,mq);
	Decoder38 U3(mq,dout);
	Decoder47 U4(mq,out7,data_out,sign);
	
endmodule