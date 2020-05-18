`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:13 05/10/2020 
// Design Name: 
// Module Name:    player 
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
module player#(
		parameter POS_X = 20,
		parameter POS_Y = 200
	)(
		input game_clk,
		input up,
		input down,
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
			if (up) begin
				if (y > 0) begin
					y <= y  - 1;
				end
			end
			else if (down) begin
				if (y < 280) begin
					y <= y + 1;
				end
			end
		end
	 end
	
endmodule
