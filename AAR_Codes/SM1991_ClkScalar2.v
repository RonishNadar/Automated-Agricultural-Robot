module Clock_Scaler_1HZ(
 
	input clk_in,
	output reg scaled_clock
);
	
	reg [31:0] out = 0;
	
	always @(posedge clk_in)
		if (out<12500000)
		begin
			out = out + 1;
		end
		else
		begin
			out = 4'b0 ;
		end
	
	always @(clk_in)
		if (out<6250000)
		begin
			scaled_clock = 1'b1;
		end
		else
		begin
			scaled_clock = 1'b0;
		end
		
endmodule


