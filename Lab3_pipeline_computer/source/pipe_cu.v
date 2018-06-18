module pipe_cu (	mrn, mm2reg, mwreg, ern, em2reg, ewreg, rsrtequ,
					op, func, rs, rt,
					wreg, m2reg, wmem, jal, aluc, aluimm, shift, regrt, sext, fwdb, fwda,
					pcsource, wpcir);

  input  [5:0] op,func;
  input  [4:0] rs, rt, ern, mrn;
  input 	     mm2reg, mwreg, em2reg, ewreg, rsrtequ;
	
  output       wreg, m2reg, wmem, jal, aluimm, shift, regrt, sext, wpcir;
  output [3:0] aluc;
  output [1:0] pcsource, fwda, fwdb;


  wire r_type = ~|op;//r_type == 1表示该指令是R型指令或者jr指令，r_type == 0 表示该指令是I型指令或者j或者jal指令
  wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
              ~func[2] & ~func[1] & ~func[0];          												//100000
  wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
              ~func[2] &  func[1] & ~func[0];          												//100010
    
  //  please complete the deleted code.

  wire i_and = r_type & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];		//100100
  wire i_or  = r_type & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0];			//100101

  wire i_xor = r_type & func[5] & ~func[4] & ~func[3] & func[2] & func[1] & ~func[0];			//100110
  wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];		//000000
  wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];		//000010
  wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];		//000011
  wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];		//001000
              
  wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; 	//001000
  wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; 	//001100

  wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & op[0];		//001101
  wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] & op[1] & ~op[0];		//001110
  wire i_lw   = op[5] & ~op[4] &  ~op[3] &  ~op[2] & op[1] & op[0];		//100011
  wire i_sw   = op[5] & ~op[4] &  op[3] &  ~op[2] & op[1] & op[0];		//101011
  wire i_beq  = ~op[5] & ~op[4] &  ~op[3] &  op[2] & ~op[1] & ~op[0];	//000100
  wire i_bne  = ~op[5] & ~op[4] &  ~op[3] &  op[2] & ~op[1] & op[0];	//000101
  wire i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] & op[1] & op[0];		//001111
  wire i_j    = ~op[5] & ~op[4] &  ~op[3] &  ~op[2] & op[1] & ~op[0];	//000010
  wire i_jal  = ~op[5] & ~op[4] &  ~op[3] &  ~op[2] & op[1] & op[0];	//000011


  reg nop, wpcir;
  reg [1:0] fwda, fwdb;

  
  always @ (*) begin
    fwda <= 2'b00;
    fwdb <= 2'b00; //default forward b: no hazards
    nop <= 0;
    wpcir <= 1;
    if (em2reg) begin
        if (ern != 0 && (ern == rs || ern == rt)) begin
          nop <= 1;
          wpcir <= 0;
        end	
    end
    if(ewreg & ((ern != 0) & (ern == rs) & ~em2reg))  //1型冒险
      begin
        fwda <= 2'b01; // select exe_alu;
      end 
    else 
      begin
        if(mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg) //2型冒险
          begin
            fwda <= 2'b10; // select mem_alu
          end 
        else 
          begin
            if(mwreg & (mrn != 0) & (mrn == rs) & mm2reg) //2型冒险
              begin
                fwda <= 2'b11;	// select mem_lw
              end
          end
      end

    if(ewreg & ((ern != 0) & (ern == rt) & ~em2reg))
      begin
        fwdb <= 2'b01; // select exe_alu;
      end 
    else 
      begin
      if(mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg) 
        begin
          fwdb <= 2'b10; // select mem_alu
        end 
      else 
        begin
          if(mwreg & (mrn != 0) & (mrn == rt) & mm2reg) 
            begin
              fwdb <= 2'b11;	// select mem_lw
            end
        end
      end
  end
  
    
      
    assign pcsource[1] = i_jr | i_j | i_jal;
    assign pcsource[0] = ( i_beq & rsrtequ ) | (i_bne & ~rsrtequ) | i_j | i_jal ;
    
    assign wreg = (~nop) & (i_add | i_sub | i_and | i_or   | i_xor  |
				 i_sll | i_srl | i_sra | i_addi | i_andi |
				 i_ori | i_xori | i_lw | i_lui  | i_jal);
   
    assign aluc[3] = (~nop) & i_sra;
    assign aluc[2] = (~nop) & (i_sub | i_or | i_srl | i_sra | i_ori | i_lui | i_beq | i_bne);
    assign aluc[1] = (~nop) & (i_xor | i_sll | i_srl | i_sra | i_xori | i_lui) ;
    assign aluc[0] = (~nop) & (i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori);
    assign shift   = (~nop) & (i_sll | i_srl | i_sra) ;

    assign aluimm  = (~nop) &(i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui);
    assign sext    = ~nop;
    assign wmem    = (~nop) & i_sw;
    assign m2reg   = (~nop) & i_lw;
    assign regrt   = (~nop) & (i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui);
    assign jal     = (~nop) & i_jal;

endmodule
