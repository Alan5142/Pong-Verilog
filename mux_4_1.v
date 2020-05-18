`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:53:57 02/15/2020 
// Design Name: 
// Module Name:    mux_4_1 
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
module mux_4_1(
		input [3:0] A,
		input [3:0] B,
		input [3:0] C,
		input [3:0] D,
		input [1:0] s,
		output [3:0] o
    );
	 assign o = s == 2'b00 ? A : s == 2'b01 ? B : s == 2'b10 ? C : D;

endmodule
