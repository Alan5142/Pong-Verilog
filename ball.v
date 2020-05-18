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
	 
	 always @ (posedge game_clk) begin
		if (rst) begin
			y <= POS_Y;
			x <= POS_X;
		end
		else begin
			
		end
	 end
	
endmodule
