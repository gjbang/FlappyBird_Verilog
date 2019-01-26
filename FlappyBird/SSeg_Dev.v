`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:19:22 01/05/2018 
// Design Name: 
// Module Name:    SSeg_Dev 
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
module SSeg_Dev(input wire clk,input wire rst,input wire Start,
input wire SW0,input flash,input wire [31:0]Hexs,input wire [7:0]point,
input wire [7:0]LES,output wire seg_clk,output wire seg_sout,output wire SEG_PEN,
output wire seg_clm
    );
	 wire [63:0]SEGMENT ;
HexTo8SEG m0(.flash(flash),.Hexs({Hexs[31:0]}),.points(point[7:0]),.LES(LES[7:0]),.SEG_TXT(SEGMENT[63:0]));
P2S m1(.clk(clk),.rst(rst),.Serial(Start),.P_Data(SEGMENT[63:0]),
.s_clk(seg_clk),.sout(seg_sout),.EN(SEG_PEN),.s_clrn(seg_clm));
endmodule
