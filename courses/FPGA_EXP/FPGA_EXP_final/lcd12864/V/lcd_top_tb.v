//=====================================================================
// module name	 :	lcd_top_tb
// project 		 : 	testbench to lcd_top
// function		 :	 & 
// create data	 :	from 2016-8-13 14:08:48 to   
// editor		 :	miao
// Tool versions : 	quartus 13.0
//=====================================================================
`timescale 1ns/1ns
module lcd_top_tb;

reg clk;
reg rst_n;

wire  cs;
wire res;
wire  rs;
wire sck;
wire sda;

LCD_top	LCD_top_inst(	
				.clk			(  clk		)					,		// system clk 50mhz 
				.rst_n			(  rst_n	)					,
							
				. cs			(   cs		)					,
				.res			(  res		)					,
				. rs			(   rs		)					,
				.sck			(  sck		)					,
				.sda			(  sda		)
				);
				
always #10 clk	=	~clk;

initial
	begin
		clk		=	0	;
		rst_n	=	0	;
		#1000 
		rst_n	=	1	;
		#200000
		$stop;
	end




endmodule
