`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:28:06 01/08/2019 
// Design Name: 
// Module Name:    ps2_ver2 
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
module ps2_ver2 (
				input clk,
				input rst,
				input ps2_clk,					//键盘时钟输入
				input ps2_data,				//键盘数据输入
				output [9:0] data_out,		//键盘扫描码输出
				output ready
    );

    reg ps2_clk_flag0, ps2_clk_flag1, ps2_clk_flag2, ps2_clk_flag3;
    wire negedge_ps2_clk;
	 

	always @ (posedge clk or posedge rst) begin			//判断键盘输出时钟是否有连续低电平
        if(rst) begin											//来应用请求发送
            ps2_clk_flag0 <= 1'b0;
            ps2_clk_flag1 <= 1'b0;
            ps2_clk_flag2 <= 1'b0; 
				ps2_clk_flag3 <= 1'b0; 
        end
        else begin
            ps2_clk_flag0 <= ps2_clk;	
            ps2_clk_flag1 <= ps2_clk_flag0;
            ps2_clk_flag2 <= ps2_clk_flag1; 
				ps2_clk_flag3 <= ps2_clk_flag2;  
        end
    end  

    assign negedge_ps2_clk = !ps2_clk_flag0 & !ps2_clk_flag1 & ps2_clk_flag2 & ps2_clk_flag3;
    reg [3:0] num;
	 always @(posedge clk or posedge rst) begin
        if(rst)
            num <= 4'd0;
        else if(num == 4'd11)
            num <= 4'd0;
        else if(negedge_ps2_clk)								//每有一时钟周期的键盘时钟低电平，计数器加一
            num <= num + 1'b1;
    end
    reg negedge_ps2_clk_shift;
    always @ (posedge clk) begin
        negedge_ps2_clk_shift <= negedge_ps2_clk;
    end
	 

    reg [7:0] temp_data;
    always @ (posedge clk or posedge rst) begin
        if(rst)
            temp_data <= 8'd0;
        else if(negedge_ps2_clk_shift) begin				//键盘时钟连续低电平后接收数据
            case(num)											//存储八个数据位			
                4'd2 : temp_data[0] <= ps2_data;
                4'd3 : temp_data[1] <= ps2_data;
                4'd4 : temp_data[2] <= ps2_data;
                4'd5 : temp_data[3] <= ps2_data;
                4'd6 : temp_data[4] <= ps2_data;
                4'd7 : temp_data[5] <= ps2_data;
                4'd8 : temp_data[6] <= ps2_data;
                4'd9 : temp_data[7] <= ps2_data;
                default : temp_data <= temp_data;
            endcase 
        end else
            temp_data <= temp_data;
    end

    reg data_break, data_done, data_expand;
    reg [9:0] data;
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            data_break <= 1'b0;
            data <= 10'd0;
            data_done <= 1'b0;
            data_expand <= 1'b0;
        end 
		  else if(num == 4'd11) begin
            if(temp_data == 8'hE0)
                data_expand <= 1'b1;						//键盘扩展键
            else if(temp_data == 8'hF0)
                data_break <= 1'b1;
            else begin
                data <= {data_expand, data_break, temp_data};
                data_done <= 1'b1;							//键盘数据已准备好输出
                data_expand <= 1'b0;
                data_break <= 1'b0;
            end  
        end 
		  else begin
            data <= data;
            data_done <= 1'b0;
            data_expand <= data_expand;
            data_break <= data_break;
        end
    end

    assign data_out = data;									//输出键盘数据
    assign ready = data_done;

endmodule
