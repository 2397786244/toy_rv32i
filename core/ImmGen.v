module ImmGen(
    input [31:0] instr,
    output reg [31:0] imm=0
);

wire  [2:0]  opcode_sel;  // I type(instr[31:20])  S type (instr[31:25],instr[11:7])
// SB type (instr[31:25] -> imm[12|10:5]   instr[11:7]-> imm[4:1|11])
// U type  (instr[31:12])
// UJ type (instr[31:12]->imm[20|10:1|11|19:12])
wire   high_bit = instr[31];
wire [19:0]  all_high=20'hfffff;
wire [19:0]  all_low=20'h00000;

InstrDiff _get_instr_diff(
    instr[6:0],
    opcode_sel
);

always@(*)begin
    case (opcode_sel)
        3'b000:begin
            imm <= {(high_bit)?all_high:all_low,instr[31:20]};
        end
        3'b001:
            imm <= {instr[31:12],12'h000};
        3'b010:
            imm <= {(high_bit)?11'h7ff:11'h000,instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
        3'b011:
            imm <= {(high_bit)?all_high:all_low,instr[31:25],instr[11:7]};
        3'b100:
            imm <= {(high_bit)?19'h7ffff:19'h00000,instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
        default:
            imm <= 32'b0;
    endcase
end
endmodule

