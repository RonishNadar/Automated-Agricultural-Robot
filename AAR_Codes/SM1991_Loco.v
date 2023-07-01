module Locomotion(
	input	 Clk_50,
	input	 [11:0] RightSensor,	 	//Right Sensor Data from ADC
	input  [11:0] MiddleSensor, 	//Middle Sensor Data from ADC
	input	 [11:0] LeftSensor,	 	//Left Sensor Data from ADC
	output reg [7:0] R_A_MtrSpeed,	//PWM pin(value) of Right motor
	output reg [7:0] R_B_MtrSpeed,	//PWM pin(value) of Right motor
	output reg [7:0] L_A_MtrSpeed,	//PWM pin(value) of Left motor
	output reg [7:0] L_B_MtrSpeed, 	//PWM pin(value) of Left motor
	output reg Stop
);
	
//Internal wire declarations
reg [7:0] NodeCount;
// localparam StateA = 4'd2;
// localparam StateB = 4'd4;
// localparam StateC = 4'd7;

localparam Straight_Speed_PWM = 10;
localparam Turn_Speed_PWM = 100;
localparam No_Speed_PWM = 0;
localparam Turn_Delay_PWM = 5;
localparam Turn_Delay = 1000;

reg CountPulse;
reg LineFlag;

		
initial begin
	R_A_MtrSpeed = 8'b0;
	R_B_MtrSpeed = 8'b0;
	L_A_MtrSpeed = 8'b0;
	L_A_MtrSpeed = 8'b0;
	CountPulse = 1'b0;
	LineFlag = 1'b0;
	Stop = 1'b0;
	end
	
	
always@(posedge Clk_50) begin 
	if(RightSensor > 1000 && LeftSensor > 1000) begin 
		//Count Node
		CountPulse = 1'b1;
		end
			
	else if (RightSensor < 1000 && LeftSensor < 1000) begin
		//Hold Node Count
		CountPulse = 1'b0;
		end
	end
	
always@(posedge Clk_50) begin
	if (NodeCount == 2 && LineFlag == 0) begin
			//Turning Left at node 2
			R_A_MtrSpeed = 30; //Turn_Speed_PWM; 
			R_B_MtrSpeed = 0; //No_Speed_PWM;
			L_A_MtrSpeed = 0; //No_Speed_PWM; 
			L_B_MtrSpeed = 100;
			if (LeftSensor < 600) begin
				if (RightSensor < 600) begin
					LineFlag = 1;
					end
				end
		end
	else if (NodeCount == 4 && LineFlag == 1) begin
			//Turning Left at node 2
			R_A_MtrSpeed = Turn_Speed_PWM; 
			R_B_MtrSpeed = No_Speed_PWM;
			L_A_MtrSpeed = No_Speed_PWM; 
			L_B_MtrSpeed = 50;
			if (LeftSensor < 600) begin
				if (RightSensor < 600) begin
					LineFlag = 0;
					end
				end
		end
	else if (NodeCount == 7 && LineFlag == 0) begin
			//Turning Left at node 2
			R_A_MtrSpeed = Turn_Speed_PWM; 
			R_B_MtrSpeed = No_Speed_PWM;
			L_A_MtrSpeed = No_Speed_PWM; 
			L_B_MtrSpeed = 80;
			if (LeftSensor < 600) begin
				if (RightSensor < 600) begin
					LineFlag = 1;
					end
				end
		end
	else if (NodeCount == 10 && LineFlag == 1) begin
			//Turning Left at node 2
			R_A_MtrSpeed = 30; //Turn_Speed_PWM; 
			R_B_MtrSpeed = 0; //No_Speed_PWM;
			L_A_MtrSpeed = 0; //No_Speed_PWM; 
			L_B_MtrSpeed = 100;
			if (LeftSensor < 600) begin
				if (RightSensor < 600) begin
					LineFlag = 0;
					end
				end
		end
	else if (NodeCount == 12 && LineFlag == 0) begin
			//Turning Left at node 2
			R_A_MtrSpeed = Turn_Speed_PWM; 
			R_B_MtrSpeed = No_Speed_PWM;
			L_A_MtrSpeed = No_Speed_PWM; 
			L_B_MtrSpeed = 50;
			if (LeftSensor < 600) begin
				if (RightSensor < 600) begin
					LineFlag = 1;
					end
				end
		end
	else if (NodeCount == 15 && LineFlag == 1) begin
			//Turning Left at node 2
			R_A_MtrSpeed = Turn_Speed_PWM; 
			R_B_MtrSpeed = No_Speed_PWM;
			L_A_MtrSpeed = No_Speed_PWM; 
			L_B_MtrSpeed = 80;;
			if (LeftSensor < 600) begin
				if (RightSensor < 600) begin
					LineFlag = 0;
					end
				end
		end
	else if (NodeCount == 18 && LineFlag == 0) begin
			//Turning Left at node 2
			R_A_MtrSpeed = No_Speed_PWM; 
			R_B_MtrSpeed = No_Speed_PWM;
			L_A_MtrSpeed = No_Speed_PWM; 
			L_B_MtrSpeed = No_Speed_PWM;
			Stop = 1'b1;

//			if (LeftSensor < 600) begin
//				if (RightSensor < 600) begin
//					LineFlag = 1;
//					end
//				end
		end
	else begin
			//continuing on straight line
//			if (MiddleSensor > 600) begin
				if(RightSensor < 600 && LeftSensor < 600) begin
					//$display("Going Forward");
					R_A_MtrSpeed = Straight_Speed_PWM; 
					R_B_MtrSpeed = No_Speed_PWM;
					L_A_MtrSpeed = Straight_Speed_PWM; 
					L_B_MtrSpeed = No_Speed_PWM;
					end

				else if(RightSensor < 600 && LeftSensor > 600) begin 
					//$display("Going Thodasa Left");
					L_A_MtrSpeed = Turn_Speed_PWM; 
					R_B_MtrSpeed = No_Speed_PWM;
					R_A_MtrSpeed = Turn_Delay_PWM; 
					L_B_MtrSpeed = No_Speed_PWM;
					end

				else if(RightSensor > 600 && LeftSensor < 600) begin
					//$display("Going Thodasa Right");
					L_A_MtrSpeed = Turn_Delay_PWM;
					R_B_MtrSpeed = No_Speed_PWM;
					R_A_MtrSpeed = Turn_Speed_PWM;
					L_B_MtrSpeed = No_Speed_PWM;
					end
			
//				end
			
			else if(RightSensor > 600 && LeftSensor > 600) begin 
				//$display("Stop");
				R_A_MtrSpeed = Straight_Speed_PWM; 
				R_B_MtrSpeed = No_Speed_PWM;
				L_A_MtrSpeed = Straight_Speed_PWM; 
				L_B_MtrSpeed = No_Speed_PWM;
				end
 
            else begin
              //$display("Stop");
				R_A_MtrSpeed = No_Speed_PWM; 
				R_B_MtrSpeed = No_Speed_PWM;
				L_A_MtrSpeed = No_Speed_PWM; 
				L_B_MtrSpeed = No_Speed_PWM;
            end
				
	end
	end
	
always@(posedge CountPulse) begin
	NodeCount = NodeCount + 1;
	end
	
		
endmodule