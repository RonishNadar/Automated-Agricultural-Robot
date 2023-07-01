// SM : Task 2 B : UART
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design UART Transmitter.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module uart(
	clk_50M,	//50 MHz clock
	Buffer,
	tx
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////


	wire baud_tick;
	reg [7:0] baud_cntr = 8'b0;

	localparam IDLE = 4'b0000;
	localparam START = 4'b0010;
	localparam DATA = 4'b0011;
	localparam STOP = 4'b0100;
	reg [3:0] present = 4'b0000;
	reg [6:0] tick_cntr = 7'b0000;
	reg out_tx = 1'b1;
	
	input wire clk_50M;
	input wire [95:0] Buffer;
	output wire tx;
	localparam N_Bits = 95;
	reg [7:0] index = N_Bits-7;
	
	reg[N_Bits:0] Paded_Data_String = 0;
	reg [7:0] d8_bit_cntr = 8'b1;

	reg n_d_status = 0;
	always @(posedge clk_50M)
		if (baud_cntr<218)
		begin
			baud_cntr = baud_cntr + 1'b1;
		end
		else
		begin
			baud_cntr = 8'b00000010 ;
		end
	assign baud_tick = (baud_cntr == 218);
	
	
	always @(posedge baud_tick)
		if (tick_cntr<21)
		begin
			tick_cntr = tick_cntr + 1'b1;
		end
		else
		begin
			tick_cntr = 5'b0 ;
		end
		
		
	always @(posedge baud_tick)
		begin
		case (present)
			
			IDLE:
				begin
				out_tx <= 1'b1;
				if ((baud_tick == 1) & (tick_cntr == 1))
					begin
					present = START;
					end
				else
					begin
					present = IDLE;
					end
				end
			
			START:
				begin
				out_tx <= 1'b0;
				if ((baud_tick == 1) & (tick_cntr == 3))
					begin
					present = DATA;
					end
				else
					begin
					present = START;
					end
				end
				
			DATA:
				begin
				if ((baud_tick == 1) & (tick_cntr == 19))
					begin
					present = STOP;
					end
				else if (tick_cntr % 2 == 0)
					begin
					out_tx <= Paded_Data_String[index];
					if (d8_bit_cntr - 8 == 0)
						begin
						index = index - 15;
						d8_bit_cntr = 8'b1;
						end
					else
						begin
						index = index + 1;
						d8_bit_cntr <= d8_bit_cntr + 1;
						end
					
					end
				else
					begin
					present = DATA;
					end
				end
			
			STOP:
				begin
				out_tx <= 1'b1;
				if ((baud_tick == 1) & (tick_cntr == 21))
					begin
					if (index != 8'b11111000)
						begin
						present = IDLE;
						end
					else
						begin
						n_d_status = 1;
						end
					end
				else if ((n_d_status == 1) & (Paded_Data_String != Buffer))
					begin
					index <= N_Bits-7;
					Paded_Data_String <= Buffer;
					n_d_status <= 0;
					end
				else
					begin
					present = STOP;
					end
				
				end
							
		endcase
		end
	assign tx = out_tx;


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////