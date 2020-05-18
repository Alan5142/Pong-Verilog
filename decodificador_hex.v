`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Compand[1]: 
// Engineer: 
// 
// Create Date:    18:54:37 02/08/2020 
// Design Name: 
// Module Name:    decodificador 
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
module decodificador_hex(
		input [3:0]data,
		input point,
		output a,
		output b,
		output c,
		output d,
		output e,
		output f,
		output g,
		output p
    );
		assign p = point;
		
		assign a = (~data[3] & ~data[2] & ~data[1] & data[0]) | (~data[3] & data[2] & ~data[1] & ~data[0]) | (data[3] & ~data[2] & data[1] & data[0]) | (data[3] & data[2] & ~data[1] & data[0]);
		assign b = (~data[3] & data[2] & ~data[1] & data[0]) | (data[2] & data[1] & ~data[0]) | (data[3] & data[2] & ~data[0]) | (data[3] & data[1] & data[0]);
		assign c = (~data[3] & ~data[2] & data[1] & ~data[0]) | (data[3] & data[2] & ~data[0]) | (data[3] & data[2] & data[1]);
		assign d = (~data[3] & data[2] & ~data[1] & ~data[0]) | (data[3] & ~data[2] & data[1] & ~data[0]) | (~data[2] & ~data[1] & data[0]) | (data[2] & data[1] & data[0]);
		assign e = (~data[2] & ~data[1] & data[0]) | (~data[3] & data[2] & ~data[1]) | (~data[3] & data[0]);
		assign f = (data[3] & data[2] & ~data[1] & data[0]) | (~data[3] & ~data[2] & data[0]) | (~data[3] & ~data[2] & data[1]) | (~data[3] & data[1] & data[0]);
		assign g = (~data[3] & data[2] & data[1] & data[0]) | (data[3] & data[2] & ~data[1] & ~data[0]) | (~data[3] & ~data[2] & ~data[1]);

endmodule