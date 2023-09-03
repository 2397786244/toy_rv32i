module CPU_Top(
    input clk,
    input rst_n
);

reg [2:0] cpu_state=0;
localparam IF = 0;
localparam ID = 1;
localparam EX = 2;
localparam MEM = 3;
localparam WB = 4;
reg pc_clk=0;
wire imem_rdy;
wire [31:0] PC;
wire [31:0] INSTR;

PC_Control _inst_pc(
    pc_clk,
    s_pc_sel,
    s_branch&branch_result,
    Imm_Out,
    R1,
    PC
);

IMem_Interface _inst_imem(
    clk,
    PC,
    imem_rdy,
    INSTR
);

//ALU signals:
wire [31:0] R1;
wire [31:0] R2;
reg  RegFile_wen=0;
wire [31:0] ALU_Result;
wire  branch_result;

RegFile _inst_regfile(
    clk,
    rst_n,
    INSTR[19:15],
    INSTR[24:20],
    INSTR[11:7],
    R1,
    R2,
    RegFile_wen,
    Data_Out
);

wire [31:0] Imm_Out;
ImmGen _inst_immgen(
    INSTR,
    Imm_Out
);

ALU _inst_alu(
    s_alu_op,
    {INSTR[5],INSTR[30],INSTR[14:12]},
    (s_alu_src1)?PC:R1,
    (s_alu_src2)?Imm_Out:R2,
    ALU_Result,
    branch_result
);

// CPU Control Signals:
wire s_branch;
wire s_mem_read;
wire [1:0] s_mem_to_reg;
wire [1:0] s_alu_op;
wire s_mem_write;
wire s_alu_src1;
wire s_alu_src2;
wire s_reg_write;
wire [1:0] s_pc_sel;

Control _inst_control(
    INSTR[6:0],
    s_branch,
    s_mem_read,
    s_mem_to_reg,
    s_alu_op,
    s_mem_write,
    s_alu_src1,
    s_alu_src2,
    s_reg_write,
    s_pc_sel
);

// DMem Read and Write Signals:
reg s_ren=0;
reg s_wen=0;
wire [31:0] DMem_Out;
wire dmem_rdy;

DMem_Interface _inst_dmem(
    clk,
    rst_n,
    s_wen,
    s_ren,
    R2,
    ALU_Result,
    DMem_Out,
    dmem_rdy
);

wire [31:0] Data_Out;
WB_Mux _inst_wbmux(
    s_mem_to_reg,
    DMem_Out,
    ALU_Result,
    PC,
    Imm_Out,
    Data_Out
);

always @(posedge clk) begin
    case(cpu_state)
        IF:begin
            RegFile_wen<=0;
            pc_clk<=0;

            if(imem_rdy)begin
                cpu_state<=ID;
            end
        end
        ID:
            cpu_state<=EX;
        EX:begin
            if(s_mem_read) s_ren<=1;
            else if(s_mem_write) s_wen <= 1;
            cpu_state<=MEM;
            end
        MEM:begin
            if(s_mem_read)begin
                if(dmem_rdy)cpu_state<=WB;
            end
            else
                cpu_state<=WB;    //waiting for data ready.
            s_ren<=0;
            s_wen<=0;
        end
        WB:
            begin
                if(s_reg_write)    // Stype and SB do not write back.
                    RegFile_wen<=1;
                pc_clk<=1;
                cpu_state<=IF;
            end
    endcase
end

endmodule

