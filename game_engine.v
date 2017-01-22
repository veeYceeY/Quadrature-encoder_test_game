`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:35:41 01/10/2017 
// Design Name: 
// Module Name:    game_engine 
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
module game_engine(
		input clk_in,
		input rst_in,
		input cw_in,
		input acw_in,
		
		output [127:0] line1_out,
		output [127:0] line2_out
    );
	
	reg clk_vel;
	reg [32:0] count_vel;
	reg [7:0] line1_buff [15:0];
	reg [7:0] line2_buff [15:0];
	wire [7:0] env1_arr [15:0];
	wire [7:0] env2_arr [15:0];
	
	reg [1:0] cw_buff,acw_buff;
	reg [4:0]load_count ;
	
	reg [7:0]car_left;
	reg [7:0] car_right;
	
	reg [7:0] line1_mix [15:0];
	reg [7:0] line2_mix [15:0];
	reg game_over;
	wire [7:0] msg_game_over[15:0];
	
	
	
	
	assign msg_game_over[15] = " ";
	assign msg_game_over[14] = " ";
	assign msg_game_over[13] = "G";
	assign msg_game_over[12] = "a";
	assign msg_game_over[11] = "m";
	assign msg_game_over[10] = "e";
	assign msg_game_over[9] =  " ";
	assign msg_game_over[8] = " ";
	assign msg_game_over[7] = "O";
	assign msg_game_over[6] = "v";
	assign msg_game_over[5] = "e";
	assign msg_game_over[4] = "r";
	assign msg_game_over[3] = " ";
	assign msg_game_over[2] = " ";
	assign msg_game_over[1] = " ";
	assign msg_game_over[0] = " ";
	
	
	assign env1_arr[15] = " ";
	assign env1_arr[14] = " ";
	assign env1_arr[13] = ">";
	assign env1_arr[12] = " ";
	assign env1_arr[11] = " ";
	assign env1_arr[10] = " ";
	assign env1_arr[9] = " ";
	assign env1_arr[8] = " ";
	assign env1_arr[7] = " ";
	assign env1_arr[6] = " ";
	assign env1_arr[5] = " ";
	assign env1_arr[4] = ">";
	assign env1_arr[3] = " ";
	assign env1_arr[2] = " ";
	assign env1_arr[1] = " ";
	assign env1_arr[0] = " ";
	
	
	assign env2_arr[15] = " ";
	assign env2_arr[14] = " ";
	assign env2_arr[13] = " ";
	assign env2_arr[12] = " ";
	assign env2_arr[11] = " ";
	assign env2_arr[10] = " ";
	assign env2_arr[9] = ">";
	assign env2_arr[8] = " ";
	assign env2_arr[7] = " ";
	assign env2_arr[6] = " ";
	assign env2_arr[5] = " ";
	assign env2_arr[4] = " ";
	assign env2_arr[3] = " ";
	assign env2_arr[2] = " ";
	assign env2_arr[1] = ">";
	assign env2_arr[0] = " ";
	
	
	
	always@(posedge clk_in) begin
		if(!rst_in) begin
			cw_buff<=2'b0;
			acw_buff<=2'b0;
			car_left<=8'h20;
			car_left<=8'h60;
		end else begin
			cw_buff[0]<=cw_buff[1];
			cw_buff[1]<=cw_in;
			acw_buff[0]<=acw_buff[1];
			acw_buff[1]<=acw_in;
			if(acw_buff==2'b01) begin
				car_left<=" ";
				car_right<="<";
			end else begin
				if(cw_buff==2'b01) begin
					car_left<="<";
					car_right<=" ";
				end
			end
		end
	end
	
	always@(posedge clk_in) begin
		if(!rst_in) begin
			game_over<=0;
		end else begin
			if((line2_buff[0]==">" && car_right=="<")|(line1_buff[0]==">" && car_left=="<")) begin
				game_over<=1'b1;
			end
		end
	end
	
	genvar b;
	generate
	for(b=15;b>0;b=b-1) begin : GameMix
		always@(posedge clk_in) begin
			if(!rst_in) begin
				line1_mix[b]<=0;
				line2_mix[b]<=0;
			end else begin
				if(!game_over) begin
					line1_mix[b]<=line1_buff[b];
					line2_mix[b]<=line2_buff[b];
				end else begin
					line1_mix[b]<=msg_game_over[b];
					line2_mix[b]<=msg_game_over[b];
				end
			end
		end
	end
	endgenerate
	
		always@(posedge clk_in) begin
			if(!rst_in) begin
				line1_mix[0]<=0;
				line2_mix[0]<=0;
			end else begin
				if(!game_over) begin
					line1_mix[0]<=car_left;
					line2_mix[0]<=car_right;
				end else begin
					line1_mix[0]<=msg_game_over[0];
					line2_mix[0]<=msg_game_over[0];
				end
			end
		end
	always @(posedge clk_in) begin
		if(!rst_in) begin
			clk_vel<=0;
			count_vel<=0;
		end else begin
			if(count_vel<=32'd6000000) begin
				count_vel<=count_vel+1;
			end
			else begin
				clk_vel<=!clk_vel;
				count_vel<=0;
			end
		end
	end
	
	genvar c;
	generate
	for (c=15;c>0;c=c-1) begin : GameMem
		always @(posedge clk_vel) begin
			if(!rst_in) begin
				line1_buff[c-1]<=0;
				line2_buff[c-1]<=0;
			end
			else begin
				line1_buff[c-1]<=line1_buff[c];
				line2_buff[c-1]<=line2_buff[c];
			end
		end
	end
	endgenerate
	
	always@(posedge clk_vel) begin
		if(!rst_in) begin
			load_count<=0;
			line1_buff[15]<=0;
			line2_buff[15]<=0;
		end else begin		
			if(load_count<5'd16) begin
				line1_buff[15]<=env1_arr[load_count];
				line2_buff[15]<=env2_arr[load_count];
				load_count<=load_count+1;
			end else begin
				line1_buff[15]<=line1_buff[0];
				line2_buff[15]<=line2_buff[0];
			end
		end
	end
		assign line1_out[7:0]=line1_mix[0];
		assign line1_out[15:8]=line1_mix[1];
		assign line1_out[23:16]=line1_mix[2];
		assign line1_out[31:24]=line1_mix[3];
		assign line1_out[39:32]=line1_mix[4];
		assign line1_out[47:40]=line1_mix[5];
		assign line1_out[55:48]=line1_mix[6];
		assign line1_out[63:56]=line1_mix[7];
		assign line1_out[71:64]=line1_mix[8];
		assign line1_out[79:72]=line1_mix[9];
		assign line1_out[87:80]=line1_mix[10];
		assign line1_out[95:88]=line1_mix[11];
		assign line1_out[103:96]=line1_mix[12];
		assign line1_out[111:104]=line1_mix[13];
		assign line1_out[119:112]=line1_mix[14];
		assign line1_out[127:120]=line1_mix[15];
		
		assign line2_out[7:0]=line2_mix[0];
		assign line2_out[15:8]=line2_mix[1];
		assign line2_out[23:16]=line2_mix[2];
		assign line2_out[31:24]=line2_mix[3];
		assign line2_out[39:32]=line2_mix[4];
		assign line2_out[47:40]=line2_mix[5];
		assign line2_out[55:48]=line2_mix[6];
		assign line2_out[63:56]=line2_mix[7];
		assign line2_out[71:64]=line2_mix[8];
		assign line2_out[79:72]=line2_mix[9];
		assign line2_out[87:80]=line2_mix[10];
		assign line2_out[95:88]=line2_mix[11];
		assign line2_out[103:96]=line2_mix[12];
		assign line2_out[111:104]=line2_mix[13];
		assign line2_out[119:112]=line2_mix[14];
		assign line2_out[127:120]=line2_mix[15];
	
endmodule
