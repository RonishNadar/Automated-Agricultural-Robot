module color_to_uart(
	clk,
	cd_input,
	red_led,
	green_led,
	blue_led,
	color_uart,
	Stop
	);
	
	input clk;
	input wire [1:0] cd_input;
	input wire Stop;
	output reg [95:0] color_uart;
	output reg red_led = 1'b0;
	output reg green_led = 1'b0;
	output reg blue_led = 1'b0;
	
	parameter RED = 2'b00;
	parameter GREEN = 2'b01;
	parameter BLUE = 2'b10;
	parameter WHITE = 2'b11;
	
	reg [3:0] color_cntr = 4'b0;
	reg red_count_status = 1'b0;
	reg green_count_status = 1'b0;
	reg blue_count_status = 1'b0;
	
	always @(posedge clk)	
	begin
		case (cd_input)
			RED:	begin
					if (red_count_status == 1'b0)
						begin
						color_cntr = 4'b0;
						red_count_status = 1'b1;
						end
					else if (red_count_status == 1'b1)
						begin
						if (color_cntr == 4'd4)
							begin
							color_uart <= {"SI-SIM1-P-#",8'h0A};
							red_count_status <= 1'b0;
							red_led <= 1'b1;
							green_led <= 1'b0;
							blue_led <= 1'b0;
							end
						else
							begin
							color_cntr = color_cntr + 1;
							end
						end
					end
			GREEN:begin
					if (green_count_status == 1'b0)
						begin
						color_cntr = 4'b0;
						green_count_status = 1'b1;
						end
					else if (green_count_status == 1'b1)
						begin
						if (color_cntr == 4'd4)
							begin
							color_uart <= {"SI-SIM1-N-#",8'h0A};
							green_count_status <= 1'b0;
							red_led <= 1'b0;
							green_led <= 1'b1;
							blue_led <= 1'b0;
							end
						else
							begin
							color_cntr = color_cntr + 1;
							end
						end
					end
			BLUE:	begin
					if (blue_count_status == 1'b0)
						begin
						color_cntr = 4'b0;
						blue_count_status = 1;
						end
					else if (blue_count_status == 1'b1)
						begin
						if (color_cntr == 4'd4)
							begin
							color_uart <= {"SI-SIM1-W-#",8'h0A};
							blue_count_status <= 1'b0;
							red_led <= 1'b0;
							green_led <= 1'b0;
							blue_led <= 1'b1;
							end
						else
							begin
							color_cntr = color_cntr + 1'b1;
							end
						end
					end
		endcase
		
		if (cd_input == WHITE)
			begin
			red_count_status <= 1'b0;
			green_count_status <= 1'b0;
			blue_count_status <= 1'b0;
			red_led <= 1'b0;
			green_led <= 1'b0;
			blue_led <= 1'b0;
			end
		if (cd_input == RED)
			begin
			green_count_status <= 1'b0;
			blue_count_status <= 1'b0;
			end
		if (cd_input == GREEN)
			begin
			blue_count_status <= 1'b0;
			red_count_status <= 1'b0;
			end
		if (cd_input == BLUE)
			begin
			red_count_status <= 1'b0;
			green_count_status <= 1'b0;
			end
		if (Stop == 1'b1)
			begin
			red_led <= 1'b0;
			green_led <= 1'b0;
			blue_led <= 1'b0;
			end
	end	
endmodule
	