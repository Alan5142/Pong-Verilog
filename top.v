`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:33:04 04/21/2020 
// Design Name: 
// Module Name:    top 
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
module top(
		input clk,
		input ps2_clk,
		input ps2_data,
		input rst,
		output VSYNC,
		output HSYNC,
		output [2:0]OutRed,
		output [2:0]OutGreen,
		output [1:0]OutBlue,
		output [7:0] leds
    );
		reg [2:0] red = 3'b000;
		reg [2:0] green = 3'b000;
		reg [1:0] blue = 2'b00;
		
		wire [15:0] keycode;
		wire read_complete;
		
		wire [9:0] pixel_column; 
		wire [9:0] pixel_row; 
		reg clk_25 = 1'b0;
		reg [7:0] tmp_data;
		
		VGA_ctrler vga(clk, red, green, blue, pixel_column, pixel_row, OutRed, OutGreen, OutBlue, HSYNC, VSYNC);
		
		keyboard kbrd (.clk(clk), .rst(rst), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .keycode(keycode), .read_complete(read_complete));
		
		always @(posedge clk) begin
			clk_25 <= ~clk_25;
		end
		
		assign leds = tmp_data;
		reg p1_up;
		reg p1_down;
		
		reg p2_up;
		reg p2_down;

		reg break_pressed = 0;
		always @ (read_complete) begin
			if (read_complete) begin
					if (keycode[15:8] == 8'hF0) begin
						break_pressed <= 1;
						
						/*
						p1_up <= keycode[15:8] == 8'h1D ? 0 : p1_up;
						p1_down <= keycode[15:8] == 8'h1B ? 0 : p1_down;
						
						p2_up <= keycode[15:8] == 8'h43 ? 0 : p2_up;
						p2_down <= keycode[15:8] == 8'h42 ? 0 : p2_down;
						*/
						
						if (keycode[7:0] == 8'h1D) begin 
							p1_up <= 0;
						end
						else if (keycode[7:0] == 8'h1B) begin 
							p1_down <= 0;
						end
						else if (keycode[7:0] == 8'h43) begin 
							p2_up <= 0;
						end
						else if (keycode[7:0] == 8'h42) begin 
							p2_down <= 0;
						end
					end
					else begin
						if (keycode[7:0] == 8'h1D) begin 
							p1_up <= ~break_pressed;
							p1_down <= break_pressed;
						end
						else if (keycode[7:0] == 8'h1B) begin 
							p1_down <= ~break_pressed;
							p1_up <= break_pressed;
						end
						else if (keycode[7:0] == 8'h43) begin
							p2_up <= ~break_pressed;
							p2_down <= break_pressed;
						end
						else if (keycode[7:0] == 8'h42) begin 
							p2_down <= ~break_pressed;
							p2_up <= break_pressed;
						end
						break_pressed <= 0;
					end
					tmp_data[0] <= p1_up;
					tmp_data[1] <= p1_down;
					tmp_data[2] <= p2_up;
					tmp_data[3] <= p2_down;
			end
		end

		contador_comparador #(
			.CNT_SIZE(23),
			.MAX_CNT(50_000)
		) game_clk (
			.clk(clk),
			.rst_b(~rst),
			.en(1'b1),
			.max_hit(game_clk_hit),
			.cnt(first_cnt)
			);
		
		
		wire [9:0] p1_x;
		wire [9:0] p1_y;
		player #(
			.POS_X(40),
			.POS_Y(170)
		) p1(.game_clk(game_clk_hit), .rst(rst), .up(p1_up), .down(p1_down), .x(p1_x), .y(p1_y));
		
		wire [9:0] p2_x;
		wire [9:0] p2_y;
		player #(
			.POS_X(550),
			.POS_Y(170)
		) p2(.game_clk(game_clk_hit), .rst(rst), .up(p2_up), .down(p2_down), .x(p2_x), .y(p2_y));
		
		always @(posedge clk_25) begin
			if (pixel_column >= p1_x & pixel_column <= (p1_x + 30) & pixel_row >= p1_y & pixel_row < (p1_y + 200)) begin
				red <= 3'b010;
				green <= 3'b111;
				blue <= 2'b01;
			end
			else if (pixel_column >= p2_x & pixel_column <= (p2_x + 30) & pixel_row >= p2_y & pixel_row < (p2_y + 200)) begin
				red <= 3'b111;
				green <= 3'b010;
				blue <= 2'b01;
			end
			else begin
				red <= 3'b000;
				green <= 3'b000;
				blue <= 2'b00;
			end
		end
endmodule
