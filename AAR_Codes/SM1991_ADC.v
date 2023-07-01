// SM : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

    reg o_din;
	 reg [11:0] d_out_ch7_temp;
	 reg [11:0] ch7;
	 reg [11:0] d_out_ch5_temp;
	 reg [11:0] ch5;
	 reg [11:0] d_out_ch6_temp;
	 reg [11:0] ch6;
	 
	 reg [4:0] o_count;
    reg [5:0] o_tempCount;

    reg [4:0] sclk_count;
    reg ADD2i, ADD1i, ADD0i;
    reg ADD2ii, ADD1ii, ADD0ii;
    reg ADD2iii, ADD1iii, ADD0iii;
	 
    initial begin
		
		o_din = 0;
		d_out_ch7_temp = 0;
		ch7 = 0;
		d_out_ch5_temp = 0;
		ch5 = 0;
		d_out_ch6_temp = 0;
		ch6 = 0;
		
      o_count = 4'd0;
      o_tempCount = 6'd0;
      sclk_count = 5'd0;
      
      ADD2i = 1'b1; 
      ADD1i = 1'b0;
      ADD0i = 1'b1;

      ADD2ii = 1'b1;
      ADD1ii = 1'b1;
      ADD0ii = 1'b0;

      ADD2iii = 1'b1;
      ADD1iii = 1'b1;
      ADD0iii = 1'b1;
    end
	 
	 assign adc_cs_n = 0;

    always @(negedge clk_50)
    begin
      if (sclk_count < 20 & adc_cs_n == 0) begin
        sclk_count <= sclk_count + 1;
        //$display("sclk_count = %d", sclk_count);
      end
      else begin
        sclk_count = 4'd1;
      end
    end

    assign adc_sck = (sclk_count < 11) ? 0 : 1;

    always @(posedge adc_sck & adc_cs_n == 0)
    begin
      if (o_count < 16) begin
        o_count <= o_count + 1;
        //$display("o_count = %d", o_count);
      end 
      else begin
        o_count = 1;
      end
    end

    always @(posedge adc_sck & adc_cs_n == 0)
    begin
      o_tempCount <= o_tempCount + 1;
      //$display("o_tempCount = %d", o_tempCount);
    end

    always @(negedge adc_sck)
    begin
    case (o_tempCount)
      2 : 
      begin
      o_din <= ADD2i;
      end
      3 : 
      begin
      o_din <= ADD1i;
      end
      4 : 
      begin
      o_din <= ADD0i;
      end
      18 :
      begin
      o_din <= ADD2ii;
      end
      19 :
      begin
      o_din <= ADD1ii;
      end
      20 :
      begin
      o_din <= ADD0ii;
      end
      34 :
      begin
      o_din <= ADD2iii;
      end
      35 :
      begin
      o_din <= ADD1iii;
      end
      36 :
      begin
      o_din <= ADD0iii;
      end
      default o_din <= 1'b0; 
      endcase 
    end
	 
	 assign din = o_din;
	 
	 always @(posedge adc_sck) begin
		case (o_tempCount)
			4:	d_out_ch7_temp[11] <= dout;
			5:	d_out_ch7_temp[10] <= dout;
			6:	d_out_ch7_temp[9] <= dout;
			7:	d_out_ch7_temp[8] <= dout;
			8:	d_out_ch7_temp[7] <= dout;
			9:	d_out_ch7_temp[6] <= dout;	
			10:d_out_ch7_temp[5] <= dout;
			11:d_out_ch7_temp[4] <= dout;
			12:d_out_ch7_temp[3] <= dout;
			13:d_out_ch7_temp[2] <= dout;
			14:d_out_ch7_temp[1] <= dout;
			15:d_out_ch7_temp[0] <= dout;
		endcase
	 end
	 always @(negedge adc_sck) begin
		case (o_tempCount)
			16 :ch7 = d_out_ch7_temp;
		endcase
	 end 
	  
	 assign d_out_ch7 = ch7;
	 
	 always @(posedge adc_sck) begin
		case (o_tempCount)
			20:d_out_ch5_temp[11] <= dout;
			21:d_out_ch5_temp[10] <= dout;
			22:d_out_ch5_temp[9] <= dout;
			23:d_out_ch5_temp[8] <= dout;
			24:d_out_ch5_temp[7] <= dout;
			25:d_out_ch5_temp[6] <= dout;	
			26:d_out_ch5_temp[5] <= dout;
			27:d_out_ch5_temp[4] <= dout;
			28:d_out_ch5_temp[3] <= dout;
			29:d_out_ch5_temp[2] <= dout;
			30:d_out_ch5_temp[1] <= dout;
			31:d_out_ch5_temp[0] <= dout;
		endcase
	 end
	 always @(negedge adc_sck) begin
		case (o_tempCount)
			32 :ch5 = d_out_ch5_temp;
		endcase
	 end 
	  
	 assign d_out_ch5 = ch5;
	 
	 always @(posedge adc_sck) begin
		case (o_tempCount)
			36:d_out_ch6_temp[11] <= dout;
			37:d_out_ch6_temp[10] <= dout;
			38:d_out_ch6_temp[9] <= dout;
			39:d_out_ch6_temp[8] <= dout;
			40:d_out_ch6_temp[7] <= dout;
			41:d_out_ch6_temp[6] <= dout;	
			42:d_out_ch6_temp[5] <= dout;
			43:d_out_ch6_temp[4] <= dout;
			44:d_out_ch6_temp[3] <= dout;
			45:d_out_ch6_temp[2] <= dout;
			46:d_out_ch6_temp[1] <= dout;
			47:d_out_ch6_temp[0] <= dout;
		endcase
	 end
	 always @(negedge adc_sck) begin
		case (o_tempCount)
			48 :ch6 = d_out_ch6_temp;
		endcase
	 end 
	  
	 assign d_out_ch6 = ch6;
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////