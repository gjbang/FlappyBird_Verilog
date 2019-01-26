`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:30:47 01/08/2019 
// Design Name: 
// Module Name:    pic 
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
module pic(
	input clk,                      
	input clrn,                     //reset the game's output
	input wire [8:0]rowaddr,        //row's address
	input wire [9:0]coladdr,        //col's address
	input wire [9:0]keydata,        //keyboard's data input
	output wire [11:0]outRGB,       //pic's output
	output death,                   //output if death
	output wire [11:0]wintime       //output win's times
    );

	
	reg judgedeath;                 
	reg [11:0]recordwintime=0;      //record the win's times
	
	reg [19:0]forrow;               //store a row's address for ram
	reg [19:0]forcol;               //store a col's address for ram
	reg [19:0]judgecol;             //store a col's address for judging id death
	
	reg [19:0]addr;                 //store a real address for ram after operating towards row and col
	
	wire [11:0] bird;               //store bird's rgb
	wire [11:0] back;               //store background's rgb
	
	reg [11:0] RGB;                 //store the RGB's data which will be outputed next pixel
	
	reg isbird=1'b0;                //judge if output bird's rgb
	reg [11:0]birdy;                //store bird's left top pixel'location
	
	reg [31:0] clkdiv;
	
	reg [19:0]movepic;              //used to move the background picture one by one

	reg [2:0]judgerestart=0;        //used to hold the start state
	reg judgepause=0;				//used to judge is pause
	
	assign outRGB=RGB;
	assign wintime=recordwintime;
	assign death=judgedeath;
	
	/*give different clock*/
	always @(posedge clk) begin
		clkdiv<=clkdiv+1'b1;
	end
	
	
	/*bird move and operate move*/
	always @(posedge clkdiv[19]) begin
		if(birdy==450) begin
			birdy=0;
		end
		
		else if(judgepause==0)begin
			birdy=birdy+1;          //bird fall down
		end
		
		if(keydata==10'b00_0001_1101) begin
			if(birdy>=10) begin
				birdy=birdy-3;      //when press 'W' in the keyboard, bird will fly
			end
		end
	
		if(clrn==0||judgerestart==1) begin
			birdy=200;              //bird's initial location
		end
	end
		
		
	/*for move out the bird's color,judge which color to be outputed*/
	always @(posedge clkdiv[1]) begin
		if(isbird==1) begin
			RGB<=bird;
		end
		else begin 
			RGB<=back;
		end
	end
	
	/*move the picture to change the background*/
	always @(posedge clkdiv[19]) begin
		if(movepic==1920) begin
			movepic=0;						//recycle again
		end
		else if(judgepause==0)begin
			movepic=movepic+1'b1;			//move
		end
		
		if(clrn==0||judgerestart==1) begin
			movepic=0;              //when rst, reset the state
		end
	end
		
	
	always @(posedge clkdiv[1]) begin
		
		/*if is start state, then show the begin state*/
		if(judgerestart==1) begin
			forrow={11'b000_0000_0000,rowaddr/2};
			forcol={10'b00_0000_0000,coladdr};
			
			forrow=forrow*320;
					
			addr=forrow+forcol/2;
			addr=addr+307200;
		
		end
		
		/*if the bird is died, then show the end state*/
		else if(judgedeath==1) begin
			forrow={11'b000_0000_0000,rowaddr/2};
			forcol={10'b00_0000_0000,coladdr};
			
			forrow=forrow*320;
					
			addr=forrow+forcol/2;
			addr=addr+230402;
		end

		/*game is running*/
		else begin
			
			/*draw bird by judging rgb*/
			if(coladdr>=0&&coladdr<=32&&rowaddr>=birdy&&rowaddr<birdy+32) begin
				/*if is bird's background, then not draw bird, but draw game's bcakgroud*/
				if(bird!=12'hcc4) begin
					addr[9:0]=({1'b0,rowaddr}-birdy)*32+coladdr%32;
					isbird=1;
				end
				else begin
					forrow={11'b000_0000_0000,rowaddr/2};
					forcol={10'b00_0000_0000,coladdr}+movepic;
				
					isbird=0;
				
					if(forcol>=19'd1280&&forcol<19'd1920) begin
						forcol=forcol-19'd1280;
						forrow=forrow*320;
					
						addr=forrow+forcol/2;
						addr=addr+153600;
					end
					else if(forcol>=19'd640&&forcol<19'd1280) begin
						forcol=forcol-19'd640;
						forrow=forrow*320;
					
						addr=forrow+forcol/2;
						addr=addr+76800;
					end
					else if(forcol>=19'd1920) begin
						forcol=forcol-19'd1920;
						forrow=forrow*320;
					
						addr=forrow+forcol/2;
					end 
					else if(forcol<19'd640) begin
						forrow=forrow*320;
					
						addr=forrow+forcol/2;
					end
				end
			end 
		/*draw bcackground*/
			else begin
				forrow={11'b000_0000_0000,rowaddr/2};
				forcol={10'b00_0000_0000,coladdr}+movepic;
				
				isbird=0;
				if(forcol>=19'd1280&&forcol<19'd1920) begin
					forcol=forcol-19'd1280;
					forrow=forrow*320;
					
					addr=forrow+forcol/2;
					addr=addr+153600;
				end
				else if(forcol>=19'd640&&forcol<19'd1280) begin
					forcol=forcol-19'd640;
					forrow=forrow*320;
					
					addr=forrow+forcol/2;
					addr=addr+76800;
				end
				else if(forcol>=19'd1920) begin
					forcol=forcol-19'd1920;
					forrow=forrow*320;
					
					addr=forrow+forcol/2;
				end 
				else if(forcol<19'd640) begin
					forrow=forrow*320;
					
					addr=forrow+forcol/2;
				end
			end				
		end
	end
	
	
	/*judge death and reocrd wintime*/
	always @(posedge clkdiv[1]) begin
		judgecol={10'b00_0000_0000,coladdr}+movepic;

		/*if clear, then it won't judge*/
		/*attention the clrn*/
		if(coladdr>=0&&coladdr<32) begin
			if(judgecol>=19'd1280&&judgecol<19'd1920) begin
				
				judgecol=judgecol-19'd1280;
				if(judgecol>=120&&judgecol<=195) begin      //第三张图第五根柱子，左边为左碰撞边界，右边为右碰撞边界
					if((birdy+30>=360)||(birdy+2<=280))    //左边为下碰撞边界，右边为上碰撞边界      
							judgedeath=1'b1;
				end
				if(forcol>=440&&forcol<=520)begin
					if((birdy+30>=400)||(birdy+2<=320))   //第六根柱子
						judgedeath=1'b1;
				end
				
				if((judgecol==200||judgecol==520)&&rowaddr==1&&judgedeath==0)begin
					recordwintime=recordwintime+1;
				end
			end
			
			
			else if(judgecol>=19'd640&&judgecol<19'd1280) begin
				
				judgecol=judgecol-19'd640;
				if(judgecol>=110&&judgecol<=200) begin
					if((birdy+30>=180)||(birdy+2<=100))
							judgedeath=1'b1;
				end
				if(forcol>=440&&forcol<=520)begin
						if((birdy+30>=140)||(birdy+2<=60))
							judgedeath=1'b1;
				end
			
				if((judgecol==200||judgecol==520)&&rowaddr==1&&judgedeath==0)begin
					recordwintime=recordwintime+1;
				end
			end
			
			else if(judgecol>=19'd1920)begin
				judgecol=judgecol-19'd1920;
				
				if(judgecol>=120&&judgecol<=195)begin
					if((birdy+30>=280)||(birdy+2<=200))
						judgedeath=1'b1;
				end
				if(judgecol>=440&&judgecol<=520)begin
					if((birdy+30>=340)||(birdy+2<=240))
						judgedeath=1'b1;
				end
				if((judgecol==200||judgecol==520)&&rowaddr==1&&judgedeath==0)begin
					recordwintime=recordwintime+1;
				end
			end
			
			else if(judgecol<19'd640) begin
				if(judgecol>=120&&judgecol<=195)begin
					if((birdy+30>=280)||(birdy+2<=200))
						judgedeath=1'b1;
				end
				if(judgecol>=440&&judgecol<=520)begin
					if((birdy+30>=340)||(birdy+2<=240))
						judgedeath=1'b1;
				end
				if((judgecol==200||judgecol==520)&&rowaddr==1&&judgedeath==0)begin
					recordwintime=recordwintime+1;
			 end
			end
		end

		/*if is the S key, or btn, then the game will reset*/
		/*S will continue, btn will reset*/
		if(keydata==10'b00_0001_1011||clrn==0) begin
			recordwintime=0;
			judgedeath=1'b0;
			if(clrn==0) begin
				judgerestart=1;
			end
		end
					
		/*if is the A key, then the game will start*/
		if(keydata==10'b00_0001_1100) begin
			judgerestart=0;
		end
		
		if(keydata==10'b00_0100_1101) begin
			judgepause=~judgepause;
		end

	end
		
				
	backpic forback(.clka(clkdiv[1]),.addra(addr[18:0]),.douta(back[11:0]));
	birdpic forbird(.a(addr[9:0]),.spo(bird[11:0]));
	


endmodule