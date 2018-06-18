module pipemem ( mwmem,malu,datain,clock,mem_clk,mmo,
				sw, hex0, hex1, hex2, hex3, hex4, hex5);	// MEM stage
	
//MEM数据存取模块。其中包含对数据同步RAM的读写访问。// 注意 mem_clock。 
//输入给该同步RAM的mem_clock 信号，模块内定义为 ram_clk。 
//实验中可采用系统 clock 的反相信号作为mem_clock 信号（亦即 ram_clk）, 
//即留给信号半个节拍的传输时间，然后在mem_clock 上沿时，读输出、或写输入。

	input  			mwmem, clock, mem_clk;
	input [9:0]		sw;
	input [31:0]   malu, datain;
	
	output [6:0] 	hex0, hex1, hex2, hex3, hex4, hex5; //mb是sw写入的数据， mmo是读出的数据，malu是写入的地址
	output [31:0] 	mmo;
		
	
	wire [31:0]  	in_port0,in_port1, in_port2;
	
	reg [31:0] 		out_port0, out_port1, out_port2, io_dataout;
	wire [31:0] 	mem_dataout;
	wire write_enable, write_dmem_enable;

	assign write_enable = mwmem;
   
	assign write_dmem_enable = (malu[7] == 1) ? 1'b0 : write_enable;
	
	lpm_ram_dq_dram  dram(malu[6:2], mem_clk, datain, write_dmem_enable, mem_dataout);	
	assign mmo = (malu[7] == 1)? io_dataout : mem_dataout;
	
	in_port_adapter FPGA2port(sw, in_port0, in_port1, in_port2);
	out_port_adapter port2FPGA(hex0, hex1, hex2, hex3, hex4, hex5, out_port0, out_port1, out_port2);

	always @(posedge mem_clk) 
		begin
			if (malu[7:2] == 6'b100000) //128 对应操作数1
				io_dataout <= in_port0;
			else if (malu[7:2] == 6'b100001) //132 对应操作数2
				io_dataout <= in_port1;
			else if (malu[7:2] == 6'b100010) //136 对应操作类型
				io_dataout <= in_port2;
			else 
				io_dataout <= 0;

			out_port0 <= in_port0;
			out_port1 <= in_port1;
			if(malu[7:2] == 6'b100011)
				out_port2 <= datain;
		end
   

endmodule
