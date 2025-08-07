//=====================================================================
// module name	 :	send_data
// project 		 : 07 LCD
// function		 :	 & 
// create data_in	 :	2016-8-13 19:30:45   
// editor		 :	miao
// Tool versions : 	quartus 13.0
//=====================================================================
module		send_data(
					  // system 	signal 
					  input				clk			,
					  input				rst_n		,
					  // external 	in-port  from lcd_ctrl 
					  input	 [7:0]		data_in		,
					  input				res_ctrl	,
					  input				rs_ctrl		,
					  input				send_start	,	// from lcd_ctrl 
					  input	[7:0]		data_rom 	,	// from rom  q 
					  // external	out-port  to   LCD12864
					  output	reg		cs			,
					  output			rs			,
					  output	reg		sda			,
					  output			res 		,
					  output	reg		sck			,
					  output	reg [3:0] cnt_shift	
					/*   output			send_done		// to  lcd_ctrl 	 */
					 );
//=========================================================================================================
//**************************     Define parameter and internal signals	  *********************************
//=========================================================================================================
// reg		[3:0]		cnt_shift		;		//	counter  to  produce	send_done 

reg 	[7:0]		data_reg	;		// data_in  plan  to send to LCD12864



assign	 rs		=	rs_ctrl		;
assign	 res 	=	res_ctrl	;

//=========================================================================================================
//********************************* 			Main 		code 		***********************************
//=========================================================================================================
//====================frequency	division to  sck============
always @ (negedge clk or negedge rst_n)		//sck'T  min 20ns   -  max 50ns 	value  40ns 
begin
     if(!rst_n)
        begin
			sck	<= 1'b0		;		
        end
     else  
		begin
            sck <=	~sck	; 
        end
end


//=======================send data_in to LCD12864==================
always @ (posedge clk or negedge rst_n)
begin
     if(!rst_n)
        begin
			cs			<=		1'b1	;
			sda 		<=		1'b0	;
			cnt_shift	<=		4'd0	;
			data_reg	<=		8'd0	;
        end
     else  
		begin
			if((rs == 0) && (cnt_shift == 0))
				begin
					data_reg <= data_in		;
				end
			else if ((rs == 1) && (cnt_shift == 0 ))
				begin
					data_reg <= data_rom 	;
				end
				
           /*  if( cnt_shift == 0 )
				begin
					data_reg	<=	data_in	;
				end
			 */
			if( send_start )
				begin
					cs			<=	1'b0	;
				end
			if( (cnt_shift < 8) && (sck == 1'b0 ) && ( send_start == 1'b1 ) )
				begin
					sda 		<=		data_reg[7]					;					
					data_reg	<=		{data_reg[6:0],data_reg[7]}	;
					cnt_shift	<=		cnt_shift 	+	1'b1		;
				end
			else if( cnt_shift == 8 )			
					begin
						cnt_shift	<=		4'd0					;
						cs			<=		1'b1					; 
					end								
        end
end


/* assign	send_done 	= (cnt_shift == 8 )? 1'b1 : 1'b0;	 */			















endmodule 