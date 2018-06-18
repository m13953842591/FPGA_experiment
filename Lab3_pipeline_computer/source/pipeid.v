module 	pipeid		(mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
							wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,
							bpc,jpc,pcsource,wpcir,wreg,m2reg,wmem,aluc,
							aluimm,da,db,dimm,drn,shift,jal);		// ID stage
							
	input  [31:0] 	inst, wdi, ealu, malu, mmo, dpc4;
	input 			mm2reg, mwreg, em2reg, ewreg, wwreg, clock, resetn;
	input  [4:0]  	ern, mrn, wrn;
	
	output [1:0] 	pcsource;
	output 			wreg, m2reg, wmem, jal, aluimm, shift, wpcir;
	output [3:0] 	aluc;
	output [31:0] 	bpc, jpc, dimm, da, db;
	output [4:0] 	drn;

	wire [31:0]   	qa, qb;
	wire [1:0] 	  	fwda, fwdb;
	wire 				rsrtequ, sext, regrt;
	wire          	e = sext & inst[15];          // positive or negative sign at sext signal
	wire [15:0]   	imm = {16{e}};                // high 16 sign bit
	wire [31:0]   	dimm; 		// sign extend to high 16
	wire [31:0]   	offset = {imm[13:0],inst[15:0],1'b0,1'b0};   //offset(include sign extend)

	wire [1:0]	pcsource_cu;
	wire  		wpcir_cu, wreg_cu, m2reg_cu, wmem_cu, aluimm_cu;
	wire [3:0] 	aluc_cu;
	wire 			shift_cu, jal_cu;
	
	assign bpc = dpc4 + offset;
	assign jpc = {dpc4[31:28], inst [25:0], 2'b0};
	assign dimm = {imm, inst[15:0]};
	
	assign pcsource = (resetn == 1)? pcsource_cu: 2'b0;
	assign wpcir = (resetn == 1)? wpcir_cu : 1'b1;
	assign wreg = (resetn == 1)? wreg_cu : 1'b0;
	assign m2reg = (resetn == 1)? m2reg_cu : 1'b0;
	assign wmem = (resetn == 1)? wmem_cu : 1'b0;
	assign jal = (resetn == 1)?  jal_cu: 1'b0;
	assign aluc = (resetn == 1)? aluc_cu : 4'b0;
	assign aluimm = (resetn == 1)? aluimm_cu : 1'b0;
	assign shift = (resetn == 1)? shift_cu : 1'b0;
	assign rsrtequ = (resetn == 1)? (da == db) : 1'b0;
	
	pipe_cu cu	(mrn, mm2reg, mwreg, ern, em2reg, ewreg, rsrtequ,
					inst[31:26], inst[5:0], inst[25:21], inst[20:16],
					wreg_cu, m2reg_cu, wmem_cu, jal_cu, aluc_cu, aluimm_cu, shift_cu, regrt, sext, fwdb, fwda,
					pcsource_cu, wpcir_cu);
					
	regfile rf (inst[25:21], inst[20:16], wdi, wrn, wwreg, clock, resetn, qa, qb);
	mux2x5 reg_drn (inst[15:11], inst[20:16], regrt, drn);
	mux4x32 mux_da (qa, ealu, malu, mmo, fwda, da);
	mux4x32 mux_db (qb, ealu, malu, mmo, fwdb, db);

endmodule


	
