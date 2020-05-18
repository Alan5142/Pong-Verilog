`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:14 05/10/2020 
// Design Name: 
// Module Name:    keyboard 
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
module keyboard(
		input clk,
		input rst,
		input ps2_clk,
		input ps2_data,
		output reg [7:0] data,
		output reg read_complete
    );
	 reg end_flag;
	 reg [3:0] state;
	 reg [7:0] internal_data;
	 initial begin
		state = 0;
		end_flag = 0;
		read_complete = 0;
	 end
	 
	 always @ (negedge ps2_clk) begin
		case (state)
			0:;
			1: internal_data[0] <= ps2_data;
			2: internal_data[1] <= ps2_data;
			3: internal_data[2] <= ps2_data;
			4: internal_data[3] <= ps2_data;
			5: internal_data[4] <= ps2_data;
			6: internal_data[5] <= ps2_data;
			7: internal_data[6] <= ps2_data;
			8: internal_data[7] <= ps2_data;
			9: end_flag <= 1; // parity
			10: end_flag <= 0; // end
		endcase
		
		if (state <= 9 & state != 0 | (state == 0 & ps2_data == 0))
			state <= state + 1;
		else state <= 0;
	end
	
	always @ (posedge clk) begin
		if (rst) begin
			read_complete <= 0;
		end
		else if (end_flag) begin
			read_complete <= 1;
			data <= internal_data;
		end
		else read_complete <= 0;
	end
endmodule
