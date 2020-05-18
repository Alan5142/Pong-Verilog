`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:01:23 05/18/2020 
// Design Name: 
// Module Name:    ball 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ball#(
		parameter POS_X = 310,
		parameter POS_Y = 265
	)(
		input game_clk,
		input [9:0] p1_x,
		input [9:0] p1_y,
		input [9:0] p2_x,
		input [9:0] p2_y,
		input rst,
		output reg [9:0] x,
		output reg [9:0] y,
		output reg point_p1,
		output reg point_p2
    );
	 reg adder_x = 1;
	 reg adder_y = 1;
	 
	 always @ (posedge game_clk, posedge rst) begin
		if (rst) begin
			y <= POS_Y;
			x <= POS_X;
			point_p1 <= 0;
			point_p2 <= 0;
		end
		else begin
			if (x == (p1_x + 30) & y >= p1_y & y < (p1_y + 200)) begin
				adder_x <= 1;
			end
			else if (x == p2_x & y >= p2_y & y < (p2_y + 200)) begin
				adder_x <= 0;
			end
			else if(y < 5) begin
				adder_y <= 1;
			end
			else if(y > 470) begin
				adder_y <= 0;
			end
			else if (x < 10) begin
				adder_x <= 1;
				point_p2 <= 1;
			end
			else if (x > 629) begin
				adder_x <= 0;
				point_p1 <= 1;
			end
			
			x <= adder_x ? x + 1 : x - 1;
			y <= adder_y ? y + 1 : y - 1;
		end
	 end
	
endmodule
