`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:01 01/08/2019 
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
	input SW,	            //used to control the vga show pictures
	input ps2_data,         //ps2's data in
	input ps2_clk,          //ps2's clock
	input rst,              //a btn input, used to reset the game
	output hs,              //used for vga's output
	output vs,              //used for vga's output
	output [3:0] r,         //vga's r
	output [3:0] g,         //vga's g
	output [3:0] b,         //vga's b
	output [7:0]LED,
	output wire [3:0] AN,
    output wire [7:0] SEGMENT,
	output wire BTN_X,	    //for btn
	output wire seg_clk,
	output wire seg_sout,
	output wire SEG_PEN,
	output wire seg_clm,
	output wire buzzer,
	input wire PM           //used to control the seven-segment LEDs to show number or graph
    );
	
	
	wire [8:0]vga_row;      //vga's row address
	wire [9:0]vga_col;      //vga's col address
	wire [9:0]getkey;       //get the keyboard input
	wire [11:0] vga_data;   //RGB's data which will be inputed the vga
	wire judgedeath;        //judge if death
	wire [11:0] judgewin;   //store the win's times
	wire btnout;            

	
	reg [31:0]clkdiv;
	reg [11:0]gametimes=0;	//record the times of playing games
	
	always @(posedge clk) begin
		clkdiv<=clkdiv+1;
	end
	

	/*output pic's rgb*/
	pic outpic(
		.clk(clk),.clrn(btnout),.rowaddr(vga_row),.coladdr(vga_col),.keydata(getkey),.outRGB(vga_data),.death(judgedeath),.wintime(judgewin)
			);

	/*mainly to show a vga*/
	vgac forvga (
		.vga_clk(clkdiv[1]), .clrn(SW), .d_in(vga_data), .row_addr(vga_row), .col_addr(vga_col), .r(r), .g(g), .b(b), .hs(hs), .vs(vs)
	);
	
	/*mainly used to give a key*/
	ps2_ver2 outkey(.clk(clk),.rst(1'b0),.ps2_clk(ps2_clk),.ps2_data(ps2_data),.data_out(getkey));


	/*mainly used to record the times*/
	pbdebounce fangdou(clkdiv[17],rst,btnout);
	disp_num arduino(clkdiv[1],{4'b0,gametimes[11:0]},4'b0,4'b0,1'b0,AN,SEGMENT);

	/*when bird died, arduino's LEDs will be on*/
	assign LED[0]=judgedeath;
	assign LED[1]=judgedeath;
	assign LED[2]=judgedeath;
	assign LED[3]=judgedeath;
	assign LED[4]=judgedeath;
	assign LED[5]=judgedeath;
	assign LED[6]=judgedeath;
	assign LED[7]=judgedeath;

	assign BTN_X=0;
	
	/*every time when pressing the btn, the times add 1*/
	always @(posedge btnout)begin
		gametimes=gametimes+1;
	end

	//seg-7 LED to show the passing times,PM is for graph or number model
	SSeg_Dev sevenseg(.clk(clk),.rst(1'b0),.Start(clkdiv[20]),.SW0(PM),.flash(1'b0),
					.Hexs({24'h000000,judgewin}),
					.point(8'b0000_0000),.LES(8'b1111_0000),
					.seg_clk(seg_clk),.seg_sout(seg_sout),.SEG_PEN(SEG_PEN),
					.seg_clm(seg_clm));
	
	//when playing ,give music
	music whenplay(.clk(clk),.playbar(judgedeath),.buzzer(buzzer));


endmodule
