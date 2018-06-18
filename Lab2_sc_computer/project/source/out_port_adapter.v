module out_port_adapter(hex0, hex1, hex2, hex3, hex4, hex5, out_port0, out_port1, out_port2);

	input [31:0] out_port0, out_port1, out_port2;
	
	output [6:0] hex0, hex1, hex2, hex3, hex4, hex5;
	
	wire [3:0] a0, a1, b0, b1, c0, c1;
	assign a0 = out_port0 % 10;
	assign a1 = out_port0 / 10;
	assign b0 = out_port1 % 10;
	assign b1 = out_port1 / 10;
	assign c0 = out_port2 % 10;
	assign c1 = out_port2 / 10;
	
	sevenseg h0(a0, hex0);
	sevenseg h1(a1, hex1);
	sevenseg h2(b0, hex2);
	sevenseg h3(b1, hex3);
	sevenseg h4(c0, hex4);
	sevenseg h5(c1, hex5);

endmodule


//4bit 的BCD码至 7 段 LED数码管译码器模块 
module sevenseg ( theta, ledsegments); 
	input [3:0] theta; 
	output [6:0] ledsegments; 
	reg [6:0] ledsegments;
	always @ (*) 
		case(theta)
			// //gfe_dcba 654_3210
			0: ledsegments = 7'b100_0000;				// DE2C板上的数码管为共阳极接法
			1: ledsegments = 7'b111_1001; 
			2: ledsegments = 7'b010_0100; 
			3: ledsegments = 7'b011_0000; 
			4: ledsegments = 7'b001_1001; 
			5: ledsegments = 7'b001_0010; 
			6: ledsegments = 7'b000_0010; 
			7: ledsegments = 7'b111_1000; 
			8: ledsegments = 7'b000_0000; 
			9: ledsegments = 7'b001_0000; 
			default: ledsegments = 7'b111_1111; 	// 其它值时全灭
	endcase
endmodule
