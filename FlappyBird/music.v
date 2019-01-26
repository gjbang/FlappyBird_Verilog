module music(
    clk,
	playbar,
	buzzer);

	input wire playbar;
	output reg buzzer;
	input wire clk;
	reg [31:0]cnt;
	reg [31:0]prediv;
	reg [31:0]delay;
	
	initial begin
		cnt=0;
		prediv =32'd382192;
		delay=32'd0;
		buzzer=1'b0;
	end
	
	always @(posedge clk)begin
		if(playbar==1'b1) begin
			buzzer<=1'b0;
			delay<=32'd0;
			cnt<=32'd0;
			prediv<=32'd382192;
		end
		else begin
			cnt<=cnt+1'b1;
			if(cnt==prediv) begin
				buzzer<=~buzzer;
				cnt<=0;
				delay<=delay+1'b1;
				case(delay)
                    32'd75:prediv<=32'd127551;
                    32'd150:prediv<=32'd113636;
                    32'd225:prediv<=32'd95547;
                    32'd300:prediv<=32'd113636;
                    32'd600:prediv<=32'd75838;
                    32'd638:prediv<=32'd127551;
                    32'd713:prediv<=32'd113636;
                    32'd788:prediv<=32'd95547;
                    32'd863:prediv<=32'd113636;
                    32'd1163:prediv<=32'd85135;
                    32'd1238:prediv<=32'd127551;
                    32'd1313:prediv<=32'd113636;
                    32'd1388:prediv<=32'd95547;
                    32'd1463:prediv<=32'd75838;
                    32'd1613:prediv<=32'd85135;
                    32'd1650:prediv<=32'd95547;
                    32'd1800:prediv<=32'd85135;
                    32'd1875:prediv<=32'd85135;
                    32'd1950:prediv<=32'd85135;
                    32'd2250:prediv<=32'd95547;
                    32'd2325:prediv<=32'd127551;
                    32'd2400:prediv<=32'd113636;
                    32'd2475:prediv<=32'd95547;
                    32'd2550:prediv<=32'd113636;
                    32'd2850:prediv<=32'd75838;
                    32'd2888:prediv<=32'd127551;
                    32'd2963:prediv<=32'd113636;
                    32'd3038:prediv<=32'd95547;
                    32'd3113:prediv<=32'd113636;
                    32'd3413:prediv<=32'd85135;
                    32'd3488:prediv<=32'd127551;
                    32'd3563:prediv<=32'd113636;
                    32'd3638:prediv<=32'd95547;
                    32'd3713:prediv<=32'd75838;
                    32'd3863:prediv<=32'd85135;
                    32'd3938:prediv<=32'd95547;
                    32'd4013:prediv<=32'd85135;
                    32'd4088:prediv<=32'd85135;
                    32'd4163:prediv<=32'd85135;
                    32'd4238:prediv<=32'd95547;
                    32'd4538:prediv<=32'd95547;
                    32'd4613:prediv<=32'd75838;
                    32'd4688:prediv<=32'd63776;
                    32'd4763:prediv<=32'd63776;
                    32'd4838:prediv<=32'd75838;
                    32'd5138:prediv<=32'd63776;
                    32'd5288:prediv<=32'd56818;
                    32'd5363:prediv<=32'd63776;
                    32'd5438:prediv<=32'd75838;
                    32'd5738:prediv<=32'd75838;
                    32'd5813:prediv<=32'd85135;
                    32'd5888:prediv<=32'd85135;
                    32'd5963:prediv<=32'd85135;
                    32'd6000:prediv<=32'd85135;
                    32'd6150:prediv<=32'd85135;
                    32'd6225:prediv<=32'd95547;
                    32'd6375:prediv<=32'd85135;
                    32'd6450:prediv<=32'd75838;
                    32'd6750:prediv<=32'd63776;
					32'd6800:
						begin
							prediv<=127551;
							delay<=32'd0;
						end
					default:prediv<=prediv;
				endcase
		end
	end
	end
	
	

endmodule
