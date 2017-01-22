`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:21:42 11/07/2016 
// Design Name: 
// Module Name:    clk_manager 
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
module clk_manager(
			input clk_i,
			input rst_i,
			output reg clk_o
    );

parameter DIVIDED_BY =200;

	reg [31:0] count;
	
	always@(posedge (clk_i),negedge (rst_i)) begin
		if(!rst_i) begin
			clk_o<=1'b0;
			count<=32'b0;
		end
		else begin
			if(count<=DIVIDED_BY) begin
				count<=count+32'b1;
			end else begin
				clk_o<=!clk_o;
				count<=32'b0;
			end
		end
	end

endmodule
