module pipemwreg (mwreg,mm2reg,mmo,malu,mrn,clock,resetn, wwreg,wm2reg,wmo,walu,wrn);	// MEM/WB 流水线寄存器
	
    //MEM/WB流水线寄存器模块，起承接MEM阶段和WB阶段的流水任务。 
    //在 clock 上升沿时，将MEM阶段需传递给WB阶段的信息，锁存在MEM/WB 
    //流水线寄存器中，并呈现在WB阶段。 

    input clock, resetn;
    input  mwreg, mm2reg;
    input [31:0] malu, mmo;
    input [4:0]  mrn; 

    output wwreg, wm2reg;
    output [31:0] walu, wmo;
    output [4:0] wrn;
    
	 reg 		wwreg, wm2reg;
	 reg [31:0] walu, wmo;
	 reg [4:0] 	wrn;
	 
    always @ (negedge resetn or posedge clock)
        if (resetn == 0) 
            begin
                walu       <= 32'b0;
                wmo        <= 32'b0;
                wrn        <=  4'b0;
                wwreg      <=  1'b0;
                wm2reg     <=  1'b0;
                wwreg      <=  1'b0;
            end 
        else
            begin 
                walu       <= malu;
                wmo        <= mmo;
                wrn        <= mrn;
                wwreg      <= mwreg;
                wm2reg     <= mm2reg;
                wwreg      <= mwreg;
            end
endmodule