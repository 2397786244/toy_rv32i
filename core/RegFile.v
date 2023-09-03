module RegFile(
    input clk,
    input rst_n,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    output reg [31:0] R1=0,
    output reg [31:0] R2=0,
    input wen,
    input [31:0] Rd_dat
);

reg [31:0] regs [0:31];

always@(*)begin
    if(rs1==0)
    begin
        R1<=0;
    end
    // else if(rs1==rd&&wen==1)begin
    //     R1<=Rd_dat;
    // end
    else
        R1<=regs[rs1];
end

always@(*)begin
    if(rs2==0)
    begin
        R2<=0;
    end
    // else if(rs2==rd&&wen==1)begin
    //     R2<=Rd_dat;
    // end
    else
        R2<=regs[rs2];
end

integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        for(i=0;i<32;i++)
            regs[i]<=0;
    end
    else if(wen&&rd!=0)
    begin
        regs[rd] <= Rd_dat;
    end
end

endmodule
