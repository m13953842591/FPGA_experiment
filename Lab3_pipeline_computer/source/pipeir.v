module pipeir (pc4,ins,wpcir,clock,resetn,dpc4,inst);	// IF/ID 流水线寄存器

	input 			clock, wpcir, resetn;
	input [31:0] 	pc4, ins;
	
	output [31:0]	inst, dpc4;

	
	wire [31:0]		pc4, ins;
	wire     		clock,resetn,wpcir;
	
	reg [31:0] 		inst, dpc4;
	
   always @ (negedge resetn or posedge clock)
      if ( resetn == 0) 
			begin
				inst[31:0] <= 32'b0;
				dpc4[31:0] <= 32'b0;
			end 
		else
			begin
				if (wpcir == 1) begin
					inst[31:0] <= ins[31:0];
					dpc4[31:0] <= pc4[31:0];
					end
			end
			
endmodule
