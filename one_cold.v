`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:08 02/15/2020 
// Design Name: 
// Module Name:    one_cold 
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
module one_cold(
		input a,
		input b,
		output reg [3:0]T
    );
	
	always @ (*) begin
		T = 4'b1111;
		case ({a, b})
			2'b00: T = 4'b1110;
			2'b01: T = 4'b1101;
			2'b10: T = 4'b1011;
			2'b11: T = 4'b0111;
		endcase
	end
endmodule
