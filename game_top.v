`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:01 01/13/2017 
// Design Name: 
// Module Name:    game_top 
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
module game_top(
			input clk_in,
			input rst_in,
			input a_in,
			input b_in,
			input c_in,
			output wire [7:4] lcd_db_out,
			output lcd_en_out,
			output lcd_rs_out,
			output lcd_rw_out
    );
	 
wire clk_lcd,rst;
wire clk_enc;
wire [127:0] line1,line2;


assign clk_lcd = clk_in;
assign rst= !rst_in;



		clk_manager #(.DIVIDED_BY (1000)) clkdiv400 (
				.clk_i(clk_in),
				.rst_i(1),
				.clk_o(clk_enc)
				);
		
		quadenc qenc (
				.clk_in(clk_enc),
				.rst_in(rst),
				.a_in(a_in),
				.b_in(b_in),
				.cw_out(cw),
				.acw_out(acw)
		);
		lcd16x2_ctrl #(.CLK_PERIOD_NS (20)) lcd(
				.clk(clk_lcd),
				.rst(rst),
				.lcd_e(lcd_en_out),
				.lcd_rw(lcd_rw_out),
				.lcd_rs(lcd_rs_out),
				.lcd_db(lcd_db_out),
				.line1_buffer(line1),
				.line2_buffer(line2)
		);
		
game_engine gameEngine(
		.clk_in(clk_in),
		.rst_in(rst),
		.cw_in(cw),
		.acw_in(acw),
		
		.line1_out(line1),
		.line2_out(line2)
    );
/*	 
assign line1[7:0]=8'h62;
assign line1[15:8]=8'h62;
assign line1[23:16]=8'h62;
assign line1[31:24]=8'h62;
assign line1[39:32]=8'h62;
assign line1[47:40]=8'h62;
assign line1[55:48]=8'h62;
assign line1[63:56]=8'h62;
assign line1[71:64]=8'h62;
assign line1[79:72]=8'h62;
assign line1[87:80]=8'h62;
assign line1[95:88]=8'h62;
assign line1[103:96]=8'h62;
assign line1[111:104]=8'h62;
assign line1[119:112]=8'h62;
assign line1[127:120]=8'h62;
			
assign line2[7:0]=8'h62;
assign line2[15:8]=8'h62;
assign line2[23:16]=8'h62;
assign line2[31:24]=8'h62;
assign line2[39:32]=8'h62;
assign line2[47:40]=8'h62;
assign line2[55:48]=8'h62;
assign line2[63:56]=8'h62;
assign line2[71:64]=8'h62;
assign line2[79:72]=8'h62;
assign line2[87:80]=8'h62;
assign line2[95:88]=8'h62;
assign line2[103:96]=8'h62;
assign line2[111:104]=8'h62;
assign line2[119:112]=8'h62;
assign line2[127:120]=8'h62;
*/	 
endmodule
