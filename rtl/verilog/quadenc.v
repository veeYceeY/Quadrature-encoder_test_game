`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:48:58 11/02/2016 
// Design Name: 
// Module Name:    quadenc 
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
module quadenc(
			input clk_in,
			input rst_in,
			input a_in,
			input b_in,
			input c_in,
			output cw_out,
			output acw_out
    );
	
	reg [7:0] a_buff,b_buff;
	reg a_valid,b_valid;
	reg [1:0] a_reg,b_reg;
	wire clk_sample,clk_sys;
	//reg clk;
	//reg [32:0] count;
	
	
	//clock devider
	/*
	always@(posedge(clk_in),negedge(rst_in)) begin
		if(!rst_in) begin
			clk<=0;
			count<=18'b0;
		end
		else begin
			if (count>10000) begin
				clk<=!clk;
			end
			else begin
				count<=count+1;
			end
		end
	end
	*/
	assign clk_sample=clk_in;
	assign clk_sys=clk_in;
	
	//debounser
	always@(posedge (clk_sample),negedge(rst_in)) begin
		if(!rst_in) begin
			a_buff<=8'd0;
			b_buff<=8'd0;
			a_valid<=1'b0;
			b_valid<=1'b0;
		end
		else begin
			a_buff[7:1]<=a_buff[6:0];
			a_buff[0]<=a_in;
			b_buff[7:1]<=b_buff[6:0];
			b_buff[0]<=b_in;
			//a_valid<=a_valid;
			//b_valid<=b_valid;
			if(a_buff==8'b11111111) begin
				a_valid<=1;
			end
			else begin
				if(a_buff==8'b00000000) begin
					a_valid<=0;
				end
			end
			if(b_buff==8'b11111111) begin
				b_valid<=1;
			end
			else begin
				if(b_buff==8'b00000000) begin
					b_valid<=0;
				end
			end
		end
	end
	
	//decoder
	always@(posedge (clk_sys),negedge(rst_in)) begin
		if(!rst_in) begin
			a_reg<=2'd0;
			b_reg<=2'd0;
		end
		else begin
			a_reg[1]<=a_reg[0];
			a_reg[0]<=a_valid;
			b_reg[1]<=b_reg[0];
			b_reg[0]<=b_valid;
		end
	end
	
	assign  cw_out = (a_reg==2'b00)&&(b_reg==2'b01);
	assign acw_out = (a_reg==2'b01)&&(b_reg==2'b00);
	/*
	always@(posedge (clk_sys)) begin
		if(!rst_in) begin
			cw_pulse<=1'b0;
			acw_pulse<=1'b0;
		end
		else begin
			if(a_reg==2'b00) begin
				if(b_reg==2'b01) begin
					cw_pulse<=1;
				end
				else begin
					cw_pulse<=0;
				end
				acw_pulse<=1'b0;
			end
			else begin
				if(b_reg==2'b00) begin
					if(a_reg==2'b01) begin
						acw_pulse<=1;
					end
					else begin
						acw_pulse<=0;
					end
					cw_pulse<=1'b1;
				end
				else begin
					cw_pulse<=0;
					acw_pulse<=0;
				end
			end
		end
	end
	*/
	//assign acw_out=acw_pulse;
	//assign cw_out=cw_pulse;
endmodule
