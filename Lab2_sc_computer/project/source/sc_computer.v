/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer (resetn,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk);
   
   input resetn,mem_clk;
   output [31:0] pc,inst,aluout,memout;
   output        imem_clk,dmem_clk;
   wire   [31:0] data;
   wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
   reg			  clock;

	
		// 分频
	initial
		begin
		  clock = 0;
		 end
		
	always@(posedge mem_clk)
		begin
			clock <= clock +1;
		end
		
   sc_cpu cpu (clock,resetn,inst,memout,pc,wmem,aluout,data);          // CPU module.
	//module sc_cpu (clock,resetn,inst,mem,pc,wmem,alu,data);
   sc_instmem  imem (pc,inst,clock,mem_clk,imem_clk);                  // instruction memory.
	
	sc_datamem 	dmem (aluout,data,memout,wmem,clock,mem_clk,dmem_clk,
						resetn, mem_dataout, io_read_data, in_port0, in_port1, in_port2,
						out_port0, out_port1, out_port2);
endmodule



