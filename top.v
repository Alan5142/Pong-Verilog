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
		wire break_code;
		
		wire [9:0] pixel_column; 
		wire [9:0] pixel_row; 
		reg clk_25 = 1'b0;
		reg [7:0] tmp_data;
		
		VGA_ctrler vga(clk, red, green, blue, pixel_column, pixel_row, OutRed, OutGreen, OutBlue, HSYNC, VSYNC);
		
		keyboard_wrapper kbrd(.clk(clk), .rst(rst), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .scan_code(keycode), .finished(read_complete), .break_code(break_code));
		
		always @(posedge clk) begin
			clk_25 <= ~clk_25;
		end
		
		assign leds[6:0] = tmp_data;
		assign leds[7] = rst;
		reg p1_up;
		reg p1_down;
		
		reg p2_up;
		reg p2_down;

		always @ (posedge clk) begin
			if (read_complete) begin
				if (break_code) begin
					if (keycode == 16'hE027) begin
						p1_up <= 0;
					end
					if (keycode == 16'hE01F) begin
						p1_down <= 0;
					end
					if (keycode == 16'hE075) begin
						p2_up <= 0;
					end
					if (keycode == 16'hE072) begin
						p2_down <= 0;
					end
				end
				else begin
					// if (keycode == 16'hE075) p1_up <= 1;
					if (keycode == 16'hE027) begin 
						p1_up <= 1;
						p1_down <= 0;
					end
					else if (keycode == 16'hE075) begin
						p2_up <= 1;
						p2_down <= 0;
					end
					else if (keycode == 16'hE01F) begin 
						p1_up <= 0;
						p1_down <= 1;
					end
					else if (keycode == 16'hE072) begin
						p2_up <= 0;
						p2_down <= 1;
					end
				end
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
		
		wire [9:0] ball_x;
		wire [9:0] ball_y;
		ball #(.POS_X(310),
				 .POS_Y(265))
				 ball(
						.game_clk(game_clk_hit),
						.p1_x(p1_x),
						.p1_y(p1_y),
						.p2_x(p2_x),
						.p2_y(p2_y),
						.rst(rst),
						.x(ball_x),
						.y(ball_y));
		
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
			else if (pixel_column >= ball_x & pixel_column <= (ball_x +10) & pixel_row >= ball_y & pixel_row < (ball_y +10)) begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			else begin
				red <= 3'b000;
				green <= 3'b000;
				blue <= 2'b00;
			end
		end
endmodule
