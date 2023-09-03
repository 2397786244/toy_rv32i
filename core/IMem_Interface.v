module IMem_Interface(
    input clk,
    input [31:0] PC,
    output reg rdy,  // instr ready.
    output reg [31:0] INSTR=0
);

reg [7:0] I_Cache [0:31];

initial begin
    $readmemh("I_Cache_Test.hex",I_Cache);
end

reg [3:0] counter=0;
always @(posedge clk) begin
    if(counter==1)begin
        INSTR<={I_Cache[PC],I_Cache[PC+1],I_Cache[PC+2],I_Cache[PC+3]};
        counter<=0;
        rdy<=1;
    end
    else begin
        INSTR<=INSTR;
        counter<=counter+1;
        rdy<=0;
    end
end

endmodule

