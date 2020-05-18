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
		output reg [15:0] keycode,
		output reg read_complete
    );
	 
	 reg [7:0] received_data;
	 reg	[7:0] previous_data;
	 reg [3:0] state;
	 reg end_flag;
	 	 
	 initial begin
		state = 0;
		end_flag = 0;
		read_complete = 0;
	 end
	 
	 always @ (negedge ps2_clk) begin
		case (state)
			0:;
			1: received_data[0] <= ps2_data;
			2: received_data[1] <= ps2_data;
			3: received_data[2] <= ps2_data;
			4: received_data[3] <= ps2_data;
			5: received_data[4] <= ps2_data;
			6: received_data[5] <= ps2_data;
			7: received_data[6] <= ps2_data;
			8: received_data[7] <= ps2_data;
			9: end_flag <= 1; // parity
			10: end_flag <= 0; // end
		endcase
		
		if (state <= 9)
			state <= state + 1;
		else state <= 0;
	end
	
	always @ (posedge clk) begin
		if (rst) begin
			keycode <= 0;
			read_complete <= 0;
			previous_data <= 0;
		end
		if (end_flag) begin
			keycode <= {previous_data, received_data};
			read_complete <= 1;
			previous_data <= received_data;
		end
		else read_complete <= 0;
	end
endmodule
