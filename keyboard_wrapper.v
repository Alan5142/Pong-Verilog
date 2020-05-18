`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:08 05/17/2020 
// Design Name: 
// Module Name:    keyboard_wrapper 
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
module keyboard_wrapper(
		input clk,
		input rst,
		input ps2_data,
		input ps2_clk,
		output reg dbg_led,
		output reg [15:0] scan_code,
		output reg break_code,
		output reg finished
    );
		reg [23:0] ps2_read_data;
		reg extended_data;
		reg sent;
		wire [7:0] data;
		wire read_complete;
		keyboard kbrd (.clk(clk), .rst(rst), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .data(data), .read_complete(read_complete));
		
		initial begin
			scan_code <= 16'h0000;
			finished <= 0;
		end
		
		always @(posedge clk) begin
			if (read_complete) begin
				if (data == 8'hF0) begin // break code
					break_code <= 1;
					dbg_led <= 1;
				end
				else begin
					if (data == 8'hE0) begin // extended
						scan_code[15:8] <= 8'hE0;
						extended_data <= 1;
					end
					else begin
						if (extended_data) scan_code[15:8] <= 8'hE0;
						else scan_code[15:8] <= 8'h00;
						scan_code[7:0] <= data;
						
						finished <= 1;
						extended_data <= 0;
						sent <= 1;
					end
				end
			end
			else begin 
				finished <= 0;
			end
			if (sent) begin
				break_code <= 0;
				sent <= 0;
				scan_code <= 0;
			end
		end
endmodule
