module CPU_Top(
    input clk
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
    2'b00,
    1'b0,
    32'd0,
    32'd0,
    PC
);

IMem_Interface _inst_imem(
    clk,
    PC,
    imem_rdy,
    INSTR
);

always @(posedge clk) begin
    case(cpu_state)
        IF:begin
            pc_clk<=0;

            if(imem_rdy)begin
                cpu_state<=ID;
            end
        end
        ID:
            cpu_state<=EX;
        EX:
            cpu_state<=MEM;
        MEM:
            cpu_state<=WB;
        WB:
            begin
                pc_clk<=1;
                cpu_state<=IF;
            end
    endcase
end

endmodule

