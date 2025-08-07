//=====================================================================
// module name	 :	LCD_top
// project 		 : 	06_LCD
// function		 :	 & 2016-8-13 13:55:30 
// create data	 :	from  to   
// editor		 :	miao
// Tool versions : 	quartus 13.0
//=====================================================================
module LCD_top(	
				input						clk			,		// system clk 50mhz 
				input						rst_n		,
										
				output 						 cs			,
				output 						res			,
				output 						 rs			,
				output 						sck			,
				output 						sda			
				);
				
/*=========================================================================================================
**************************************      internal links		     **************************************
=========================================================================================================*/	

wire [7:0]	data				;
wire		clk_5M				;
	
wire [3:0]	cnt_shift			;
wire 		res_ctrl			;
wire		rs_ctrl				;
wire 		start_send			;
wire [9:0]	address				;
wire [7:0]	q 					;



/*=========================================================================================================
********************************* 			instantiation		      ********************************
=========================================================================================================*/	
PLL	PLL_inst (
	.inclk0 ( clk ),
	.c0 ( clk_5M )
	);
	
LCD_ctrl 			/* #(
					.COLMAX(6)	,
					.PAGEMAX(4)
						) */
					LCD_ctrl(
					
					.clk			( clk_5M	  )				,		//	clk from pll 5M 
					.rst_n			( rst_n		  )				,		//	system	reset 
								
					.cnt_shift		( cnt_shift	  )				,		//	 from   send_data  
								
					.data			( data		  )				,
					.res_ctrl		( res_ctrl	  )				,
					.rs_ctrl		( rs_ctrl	  )				,
					.start_send		( start_send  )				,
					.address		( address  	  )
				   );
				  
send_data send_data_inst(
					 
					  .clk				(  clk_5M		 )					,
					  .rst_n			(  rst_n		 )					,
								
					  .data_in			(  data			 )					,
					  .res_ctrl			(  res_ctrl		 )					,
					  .rs_ctrl			(  rs_ctrl		 )					,
					  .send_start		(  start_send	 )					,	// from lcd_ctrl
					  .data_rom 		(   q			 )					,
									
					  .cs				(  cs			 )					,
					  .rs				(  rs			 )					,
					  .sda				(  sda			 )					,
					  .res 				(  res 			 )					,
					  .sck				(  sck			 )					,
					  .cnt_shift	    (  cnt_shift	 )
					/*   output			send_done		// to  lcd_ctrl 	 */
					 );
ROM	ROM_inst (
	.address ( address ),
	.clock ( clk ),
	.q ( q )
	);

	
					 
endmodule 
