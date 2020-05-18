`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:41 05/18/2020 
// Design Name: 
// Module Name:    score 
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
module score(
		input clk,
		input p1_point,
		input p2_point,
		input rst,
		output reg [3:0] score_1,
		output reg [3:0] score_2
    );
		// process data
		always @(posedge clk) begin
			if (rst) begin
				score_1 <= 0;
				score_2 <= 0;
			end
			if (p1_point) begin
				score_1 <= score_1 + 1;
			end
			else if (p2_point) begin
				score_2 <= score_2 + 1;
			end
		end
endmodule
