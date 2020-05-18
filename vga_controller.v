// ============================================================
// Title       : VGA controller
// Project     : 
// File        : VGA_ctrler.v
// Description : VGA controller
// Revisions   : 
// ============================================================
// Author      : Carlos Vazquez
// Course      : Disenio Digital
// ============================================================

module VGA_ctrler(
  input            clk_50,						// 50MHz Clock input
  
  input      [2:0] red_in,							// Red color input, when generated outside
  input      [2:0] green_in,						// Green color input, when generated outside
  input      [1:0] blue_in,							// Blue color input, when generated outside
  
  output reg [9:0] pixel_column,					// Column pixel counter
  output reg [9:0] pixel_row,							// Row pixel counter
  
  output reg [2:0] red_out,				// Red color output, to VGA connector
  output reg [2:0] green_out,			// Green color output, to VGA connector
  output reg [1:0] blue_out,				// Blue color output, to VGA connector
  output reg       horiz_sync_out,	// Horizontal Sync output, to VGA connector
  output reg       vert_sync_out	   // Vertical Sync output, to VGA connector
  );

  reg clk_25 = 0;									// 25MHz internal clock
  
  reg horiz_sync = 0;							// Internal horizontal sync
  reg vert_sync = 0;							// Internal vertical sync
  
  wire video_on;									// Monitors when pixels are printed
  reg video_on_v = 0;						// Monitors the 480 lines of printed resolution
  reg video_on_h = 0;						// Monitors the 680 columns of printed resolution
  
 
  reg [9:0] v_count = 0;					// Vertical line counter
  reg [9:0] h_count = 0;					// Horizontal column counter
  reg [20:0] Scrn_cntr =0;				// Frame (screen) counter
  
  wire [2:0]  red1;								// Red info
  wire [2:0]  green1;							// Green info
  wire [1:0]  blue1;								// Blue info
  
  
  // video_on - 1 - when in the 640x480 printed pixels
  assign video_on = video_on_h && video_on_v;
  
  // assignment of color info (default on white, commented comming from outside)
  assign red1 = red_in;//pixel_row[4:2] + Scrn_cntr[4:2];//3'b111;//red_in;
  assign green1 = green_in;//pixel_row[7:5] + Scrn_cntr[4:2];//3'b111;//green_in;
  assign blue1 = blue_in;//pixel_row[9:8] + Scrn_cntr[4:3];//2'b11;//blue_in;
  
  // 25MHz clock generation
  always @(posedge clk_50) clk_25 <= ~clk_25;
  
  always @(posedge clk_25)
  begin
    ////////////////////////////////// H-Sync ///////////////////////////////////
	 // ** Count starts at Tdisp **
    if ( h_count == (10'd800) ) 
      h_count <= 10'd0;
    else
      h_count <= h_count + 1;
    
	 //from 640 + 16 = 656 counts to  640 + 16 + 96 = 752 counts
    if (( h_count < (10'd752)) && (h_count > (10'd656)) )
      horiz_sync <= 1'b0;
    else
      horiz_sync <= 1'b1;
    
    if ( h_count <= (10'd640) ) 
    begin
      video_on_h <= 1'b1;
      pixel_column <= h_count;
    end
    else
      video_on_h <= 1'b0;
    //////////////////////////////// End H-Sync /////////////////////////////////
  
    ////////////////////////////////// V-Sync ///////////////////////////////////
    // ** Count starts at Tdisp **
	 if (( v_count > 10'd521 ) && ( h_count > 10'd799 )) 
    begin
      v_count <= 10'd0;
		Scrn_cntr <= Scrn_cntr + 1;
    end
    else if ( h_count == 10'd799 ) 
      v_count <= v_count + 1'b1;
    
	 // from 480 + 10 = 490 lines  to  480 + 10 + 2 = 492 lines
    if (( v_count < 10'd492 ) && ( v_count > 10'd490 )) 
      vert_sync <= 1'b0;
    else
      vert_sync <= 1'b1;
    
    if ( v_count <= 10'd480 ) 
    begin
      video_on_v <= 1'b1;
      pixel_row <= v_count;
    end
    else
      video_on_v <= 1'b0;
    /////////////////////////////// End V-Sync //////////////////////////////////    
    
    /////////////////////////////// Pixel assign ////////////////////////////////
    if (video_on == 1'b1) 
    begin
      red_out <= red1;
      blue_out <= blue1;
      green_out <= green1;
    end
    else
    begin
      red_out <= 3'b00;
      blue_out <= 3'b00;
      green_out <= 2'b00;
    end
    ///////////////////////////// End Pixel assign //////////////////////////////
    
    horiz_sync_out <= horiz_sync;
    vert_sync_out <= vert_sync;

  end
endmodule