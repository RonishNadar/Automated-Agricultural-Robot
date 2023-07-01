// FPGA Bot : Task 1 D : PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 50Mhz Clock Frequency to 1Mhz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : Clk, DUTY_CYCLE
//Output : PWM_OUT

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////

module PWM_Generator(
 
	input clk,             // Clock input
	input [7:0]DUTY_CYCLE, // Input Duty Cycle
	output PWM_OUT         // Output PWM
);
 
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

	//Clock Scaler//
	reg [2:0] out;
	reg hi_fi;
	
	always @(posedge clk)
		if (out<4)
		begin
			out = out + 1;
		end
		else
		begin
			out = 6'b0 ;
		end
	
	always @(*)
		if (out<2)
		begin
			hi_fi = 1'b1;
		end
		else
		begin
			hi_fi = 1'b0;
		end
	
	//Ten Counter//
	reg [3:0] ten_out;
	
	always @(posedge hi_fi)
		if (ten_out<9)
		begin
			ten_out = ten_out + 1;
		end
		else
		begin
			ten_out = 4'b0 ;
		end
	
	wire [9:0]int_duty;
	assign int_duty = (((10) * DUTY_CYCLE)/100);
	
	assign PWM_OUT = (ten_out < int_duty);

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////