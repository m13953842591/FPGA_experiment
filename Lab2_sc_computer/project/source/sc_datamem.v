module sc_datamem (addr, datain, dataout, we, clock, mem_clk, dmem_clk,
						resetn, mem_dataout, io_read_data, in_port0, in_port1, in_port2,
						out_port0, out_port1, out_port2);
 
   input [31:0]   addr;
   input [31:0]   datain;
	input          resetn;
   input          we, clock, mem_clk;
	input [31:0]   in_port0, in_port1, in_port2;
	
   output [31:0]  dataout;
   output         dmem_clk;
	output [31:0]  out_port0, out_port1, out_port2;
	output [31:0]  mem_dataout;
	output [31:0]  io_read_data;
	
   wire           dmem_clk;    
   wire           write_enable;
	wire 				writ_datamem_enable, write_io_output_reg_enable;
	wire[31:0]     mem_dataout;
	reg[31:0] 		out_port0, out_port1, out_port2, io_read_data;
	
   assign         write_enable = we & ~clock;
   assign         dmem_clk = mem_clk & ( ~ clock);
	assign         writ_datamem_enable = write_enable & (~addr[7]);
	assign         write_io_output_reg_enable = write_enable & (addr[7]);
	
	mux2x32 mem_io_dataout_mux(mem_dataout, io_read_data, addr[7], dataout);
   
   lpm_ram_dq_dram  dram(addr[6:2],dmem_clk,datain,write_enable, mem_dataout );
	
	always @(posedge mem_clk) 
		begin
			if (addr[7:2] == 6'b100000) //128 对应操作数1
				io_read_data <= in_port0;
			else if (addr[7:2] == 6'b100001) //132 对应操作数2
				io_read_data <= in_port1;
			else if (addr[7:2] == 6'b100010) //136 对应操作类型
				io_read_data <= in_port2;
			else 
				io_read_data <= 0;

			out_port0 <= in_port0;
			out_port1 <= in_port1;
			if(addr[7:2] == 6'b100011) //144对应运算结果
				out_port2 <= datain;
		end

endmodule 