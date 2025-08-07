//=====================================================================
// module name	 :	LCD_ctrl 
// procolect 		 : 	06_LCD
// function		 :	 & 
// create data	 :	from 2016-8-12 20:33:19 to   
// editor		 :	miao
// Tool versions : 	quartus 13.0
//=====================================================================
module  LCD_ctrl(
					// system signal 
					input 				clk				,		//	clk from pll 5M 
					input				rst_n			,		//	system	reset 
					// external in-port
					input		[3:0]	cnt_shift		,		//	 from   send_data  
					//  out-port 
					output reg 	[7:0]	data			,
					output reg 			res_ctrl		,
					output reg 			rs_ctrl			,
					output reg 			start_send		,
					output reg 	[9:0]	address			
				   );
//=========================================================================================================
//**************************     Define parameter and internal signals	  *********************************
//=========================================================================================================
parameter  ADDRMAX	=	1023	;		//address max 

reg 	[9:0]		state	;
reg 	[3:0]		cnt		;	//counter for 1us 
			
reg 	[3:0]		page	;	// page 8 
reg 	[7:0]		col		;	// col  128 

parameter	COLMAX		=	128 	; //  col  max 
parameter	PAGEMAX 	= 	8 		; //  pgae  max  

parameter	IDLE			=		5'd0 	,
			POWERUP         =		5'd1    ,
			SOFTRES1        =		5'd2    ,
			VOLUP1          =		5'd3    ,
			VOLUP2          =		5'd4    ,
			VOLUP3          =		5'd5    ,
			ADJUST1         =		5'd6    ,
			ADJUST2         =		5'd7    ,
			ADJUST3         =		5'd8    ,
			VOLSLAN         =		5'd9    ,
			ROWSCAN         =		5'd10   ,
			COLSCAN			=		5'd11   ,
			STARTSCAN       =		5'd12   ,
			DISPLAY         =		5'd13   ,
			DATAWR          =		5'd14   ,
			S15             =		5'd15   ,
			S16			    =		5'd16   ,
			JUDGE           =		5'd17   ,
			STOP            =		5'd18   ;

parameter	DATASEND		=		8'b0000_0001	;
			

//=========================================================================================================
//********************************* 			Main 		code 		***********************************
//=========================================================================================================

always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				data		<=	8'h00			;
				state		<=	1'b0			;
				cnt			<=	1'b0			;
				page		<=	1'b0			;
				col			<=	1'b0			;
				rs_ctrl		<=	1'b0			;
				start_send	<=	1'b0			;
				res_ctrl	<=	1'b0			;
				address		<=	8'd0 			;
			end
		else
			begin
				case(state)
					IDLE:	// 0 
						begin
							state 	<=  POWERUP	;	
						end
//-----------------------------LCD initialize---------------------------------
					POWERUP:			//	1   power up delay 1us
						begin		
							if( cnt < 8 )				//  200ns * 8  = 1600ns 
								begin
									cnt			<=	cnt	+	1'b1	;
									res_ctrl	<=	1'b0			; 		// keep 1us  res 
								end
							else
								begin
									cnt			<=		1'b0		;
									state		<=		SOFTRES1	;
									res_ctrl	<=		1'b1		;
									data		<=		8'he2		;		//data prepare  
								end
						end
					SOFTRES1:		//  2
						begin						// soft reset 
							rs_ctrl	<=	0 ;		// select command register 
							if( cnt_shift < 8 )
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)    //  send data done  
										begin
											state		<=	VOLUP1		;
											start_send	<=	1'b0		;
											data		<=	8'h2c		;	// data prepare 
										end
								end
						end
					VOLUP1:
						begin			// 3    soft up vol  first 1    
							if(cnt_shift < 8)
								start_send 	<=	1;
							else
								begin
									if(cnt_shift ==8)				//send data  done  
										begin
											state		<=	VOLUP2 	;
											start_send	<=	1'b0	;
											data		<=	8'h2e	;
										end
								end
						end
					VOLUP2:		// 4 vol up second  
						begin			
							if(cnt_shift < 8)
								start_send  <=  1'b1  ;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=	VOLUP3	;
											data		<=	8'h2f	;
											start_send	<=	1'b0	;
										end
								end
						end
					VOLUP3:			// 5 vol up thrid  
						begin 
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=	ADJUST1			;		// adjust simpale contrast 
											start_send	<=	1'b0			;
											data		<=	8'h23			;
										end
								end
						end
					ADJUST1:	// 6  adjust simpale contrast range  0x20～0x27
						begin
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state 		<= 	ADJUST2	;
											start_send	<=	1'b0	;
											data		<=	8'h81	;
										end
								end
					end
					ADJUST2:	// 7  adjust micro  contrast 
						begin		
							if(cnt_shift < 8)
								start_send <= 1;
							else
								begin
									if(cnt_shift == 8)			
										begin
											state		<=	ADJUST3	;
											start_send	<=	1'b0	;
											data		<=	8'h1a	;
										end
								end
						end
					ADJUST3:			// 8  adjust micro  contrast  value range 0x00～0x3f
						begin			//  micro adjust value
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=		VOLSLAN		;
											start_send	<=		1'b0		;
											data		<=		8'ha2		;
										end
								end
						end
					VOLSLAN:			// 9
						begin						//  vol  slanting 
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=		ROWSCAN		;
											start_send	<=		1'b0		;
											data		<=		8'hc0		;
										end
								end
						end
					ROWSCAN:				// row scan from up to down  10  command 
						begin						
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=		COLSCAN		;
											start_send	<=		1'b0		;
											data		<=		8'ha1		;
										end
								end
						end
					COLSCAN:			//	 col scan from  left to right  11	command
						begin				
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=		STARTSCAN	;
											start_send	<=		1'b0		;
											data		<=		8'h40		;
										end
								end
						end
					STARTSCAN:
						begin 			//  start row  from  1  12   command
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=		DISPLAY		;
											start_send	<=		1'b0		;
											data		<=		8'haf		;
										end
								end
						end
					DISPLAY:				// 13  display start command
						begin					
							if(cnt_shift < 8)
								start_send	<=	1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=		DATAWR		;
											start_send	<=		1'b0		;
											data		<=		8'hb0		;		// command  page address 
										end
								end
						end
//-------------------------------write data to LCD-------------------------------
					DATAWR:						//  14   
						begin
							if( page < PAGEMAX )
								begin
									if( cnt_shift < 8)
										start_send <= 1'b1 ;
									else		
										begin
											if( cnt_shift == 8 )
												begin
													state		<=	S15		;
													start_send	<=	1'b0	;
													data		<=	8'h10	;		// command 
												end
										end
								end
							else
								begin
									state	<=  STOP ;
								end
						end
					S15:					//  send command  15
						begin
							if(cnt_shift < 8)
								start_send 	<= 	1'b1	;
							else
								begin
									if(cnt_shift==8)
										begin
											state		<=		S16		;
											start_send	<=		1'b0	;
											data		<=		8'h00	;		// command
										end
								end
						end
					S16:			// send command   16
						begin
							if(cnt_shift < 8)
								start_send 	<=	1'b1	;
							else
								begin
									if(cnt_shift == 8)
										begin
											state		<=	JUDGE				;
											start_send	<=	1'b0				;
											data		<=	DATASEND			;	// send data   
										end
								end
						end
					JUDGE:
						begin			// 	send  data  17
							if(col < COLMAX )
								begin
									rs_ctrl	<=	1'b1	;
									if(cnt_shift < 8)
										start_send	<=	1'b1	;
									else if(cnt_shift == 8)
												begin
													col	<=	col	+	1'b1	;													
													start_send	<=	1'b0	;													
													if(col == (COLMAX-1))
														page	<=	page	+	1'b1	;
													if(address < ADDRMAX )
														address	<=	address + 1'b1		;
													else 	address	<=	1'b0			;
												end										
								end
							else
								begin
									col			<=	1'b0			;
									rs_ctrl		<=	1'b0			;
									state		<=	DATAWR			;
									data		<=	8'hb0 +	page	;	// page  address  send 
								end
						end
					STOP:         //  18
						begin
							state	<=	STOP	;
						end
					default:;
					endcase
			end
	end
endmodule
