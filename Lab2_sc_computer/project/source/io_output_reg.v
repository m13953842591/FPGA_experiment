module io_output_reg (addr,datain,write_io_enable,io_clk,clrn,out_port0,out_port1, out_port2, out_port3); 

	input [31:0] addr,datain;
	input write_io_enable,io_clk;
	input clrn;

	//reset signal. if necessary,can use this signal to reset the output to 0. 
	output  [31:0]  out_port0,out_port1, out_port2, out_port3;

	reg [31:0] out_port0;     // output port0
	reg [31:0] out_port1;     // output port1
	reg [31:0] out_port2;
	reg [31:0] out_port3;

	always @(posedge io_clk or negedge clrn)
		begin
			if (clrn == 0)
				begin                 // reset
					out_port0 <=0;
					out_port1 <=0;      // reset all the output port to 0.
					out_port2 <=0;
					out_port3 <=0;
				end
			else
				begin
					if (write_io_enable == 1)
						case (addr[7:2])
						6'b100000: out_port0 <= datain;   // 80h
						6'b100001: out_port1 <= datain;   // 84h // more ports，可根据需要设计更多的输出端口。
						6'b100010: out_port2 <= datain;
						6'b100011: out_port3 <= datain;
						endcase
				end
		end
endmodule 