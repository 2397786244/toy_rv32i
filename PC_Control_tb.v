module PC_Control_tb();
reg clk=0;
wire [31:0] PC;
reg [1:0] PC_Sel=00;
reg branch=0;
reg [31:0] Imm=0;
reg [31:0] R_rs1=0;

PC_Control _inst_PC_control(
    clk,
    PC_Sel,
    branch,
    Imm,
    R_rs1,
    PC
);

initial
begin
    // PC+=4
    #1 PC_Sel=2'b00;
    // branch success.
    #2 PC_Sel=2'b01;
       branch=1;
       Imm=32'd10;

    // jalr
    #5 PC_Sel=2'b10;
        Imm=-32'd10;
        branch=0;

    // jal
    #5 PC_Sel=2'b11;
        Imm=32'd0;
        branch=0;
        R_rs1=32'h00008000;

    //branch failed
    #5 PC_Sel=2'b01;
        branch=0;
        Imm=-32'h8000;
        R_rs1=0;
    #5 PC_Sel=2'b10;
        Imm=-32'h8000;
        branch=0;

end

initial
begin
    #1  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;

    #4  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;

    #4  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;

    #4  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;

    #4  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;

    #4  clk=1;
    #1  clk=0;
    #4  clk=1;
    #1  clk=0;

    #1000 $finish;
end

initial begin
        $dumpfile("pc_control_tb.vcd");
        $dumpvars(0,PC_Control_tb);
end

endmodule
