module Color_Detection(
	scaled_clock,
	scaled_clock_200ms,
	cs_output,
	cs_en,
	cs_S0,
	cs_S1,
	cs_S2,
	cs_S3,
	red,			//
	green,		//
	blue,			//
	white,		//
	pos_cntr,	//
//	red_led,
//	green_led,
//	blue_led,
	cd_out
);

input scaled_clock, cs_output, scaled_clock_200ms;

output reg cs_S0 = 1'b1;
output reg cs_S1 = 1'b0;
output reg cs_en = 1'b0;
output reg cs_S2 = 1'b0;
output reg cs_S3 = 1'b0;
//output reg red_led = 1'b0;
//output reg green_led = 1'b0;
//output reg blue_led = 1'b0;
output reg [1:0]cd_out = 00;


output reg [15:0] pos_cntr = 16'b0;		//
output reg [15:0] red = 16'b0;			//
output reg [15:0] green = 16'b0;			//
output reg [15:0] blue  = 16'b0;			//
output reg [15:0] white  = 16'b0;		//

reg [3:0] present = 4'b0000;
localparam stateRed = 2'b00;
localparam stateGreen = 2'b01;
localparam stateBlue = 2'b10;
	
always @(posedge scaled_clock)
	begin
		if ((pos_cntr == 65535) || (cs_output == 1'b1))
		begin
			pos_cntr = 16'b0;
			
		end
		else
		begin
			pos_cntr = pos_cntr + 1'b1 ;
		end
	end

always @(posedge cs_output)
	begin
	if ((cs_S2 == 1'b0) && (cs_S3 == 1'b0))
		begin
		red <= pos_cntr;
		end
	else if((cs_S2 == 1'b1) && (cs_S3 == 1'b1))
		begin
		green <= pos_cntr;
		end
	else if((cs_S2 == 1'b0) && (cs_S3 == 1'b1))
		begin
		blue <= pos_cntr;
		end
	else if((cs_S2 == 1'b1) && (cs_S3 == 1'b0))
		begin
		white <= pos_cntr;
		end
	end	
	
always @(negedge scaled_clock_200ms)
	begin
		case (present)
		4'd0:
			begin
			cs_S2 <= 1'b0;
			cs_S3 <= 1'b0;
			present <= 4'd1;
			end
		
		4'd1:
			begin
			cs_S2 <= 1'b1;
			cs_S3 <= 1'b1;
			present <= 4'd2;
			end
			
		4'd2:
			begin
			cs_S2 <= 1'b0;
			cs_S3 <= 1'b1;
			present <= 4'd3;
			end
			
		4'd3:
			begin
			cs_S2 <= 1'b1;
			cs_S3 <= 1'b0;
			present <= 4'd0;
			end
		endcase
	end

always @(negedge scaled_clock_200ms)
	begin
		if ((white < 10'd80) || (white > 10'd250))
			begin
//				red_led <= 1'b0;
//				green_led <= 1'b0;
//				blue_led <= 1'b0;
				cd_out <= 11;
			end
		else
			begin
				if ((red < green) && (red < blue))
					begin
//						red_led <= 1'b1;
//						green_led <= 1'b0;
//						blue_led <= 1'b0;
						cd_out <= 00;
					end
					
				if ((green < red) && (green < blue))
					begin
//						red_led <= 1'b0;
//						green_led <= 1'b1;
//						blue_led <= 1'b0;
						cd_out <= 01;
					end
					
				if ((blue < red) && (blue < green))
					begin
//						red_led <= 1'b0;
//						green_led <= 1'b0;
//						blue_led <= 1'b1;
						cd_out <= 10;
					end
			end
	end

endmodule
