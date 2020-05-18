`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:32 04/18/2020 
// Design Name: 
// Module Name:    contado_comparador 
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
module contador_comparador#(
		parameter CNT_SIZE = 4,
		parameter MAX_CNT = 9
	)(
		input clk,
		input rst_b,
		input en,
		output max_hit,
		output reg [CNT_SIZE-1:0] cnt
    );

	wire rst_flop;
	wire [CNT_SIZE-1:0] nxt_cnt;
	
	assign rst_flop = rst_b & (~max_hit);
	
	always @(posedge clk) begin
		if (!rst_flop)
			cnt <= {CNT_SIZE{1'b0}};
		else if (en)
			cnt <= nxt_cnt;
	end
	
	assign nxt_cnt = cnt + {{CNT_SIZE-1{1'b0}}, 1'b1};
	
	assign max_hit = (cnt == MAX_CNT) ? 1'b1 : 1'b0;

endmodule
