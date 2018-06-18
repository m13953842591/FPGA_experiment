module 	pipeif(pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock); // IF stage
	
//IF取指令模块，注意其中包含的指令同步ROM存储器的同步信号， 
//即输入给该模块的mem_clock 信号，模块内定义为 rom_clk。// 注意 mem_clock。 
//实验中可采用系统 clock 的反相信号作为mem_clock（亦即 rom_clock）, 
//即留给信号半个节拍的传输时间。 

	input [31:0] 	pc, bpc, da, jpc;
	input [1:0]		pcsource;
	input 			mem_clock;
	output [31:0] 	npc, ins, pc4;
	wire 	[31:0] 	pc4; //输入到pcmux的线

	assign pc4 = pc + 4;

	lpm_rom_irom irom (pc[7:2],mem_clock,ins);

	mux4x32 muxpc(pc4, bpc, da, jpc, pcsource, npc);

endmodule
