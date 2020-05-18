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
		output reg [9:0] y
    );
	 reg signed[1:0] adder_x = 1;
	 reg signed[1:0] adder_y = 1;
	 
	 always @ (posedge game_clk) begin
		if (rst) begin
			y <= POS_Y;
			x <= POS_X;
		end
		else begin
			if (x == (p1_x + 30) & y >= p1_y & y < (p1_y + 200)) begin
				adder_x <= 1;
			end
			else if (x == p2_x & y >= p2_y & y < (p2_y + 200)) begin
				adder_x <= -1;
			end
			else if(y == 0) begin
				adder_y <= 1;
			end
			else if(y == 640) begin
				adder_y <= -1;
			end
			else begin
				x <= x + adder_x;
				y <= y + adder_y;
			end
		end
	 end
	
endmodule
