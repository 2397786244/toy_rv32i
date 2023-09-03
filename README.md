+ Implemented a subset of RV32I:
    + addi slli xori srli srai ori andi jalr lw
    + auipc lui
    + add sub sll xor srl sra or and
    + beq blt bge
    + jal
    + sw
+ core
    + CPU_Top.v
    + PC_Control.v
    + IMem_Interface.v
    + RegFile.v
    + ALU.v
    + Control.v
    + DMem_Interface.v
    + ImmGen.v
    + InstrDiff.v
    + WB_Mux.v
+ testbench
+ periph
    + uart
