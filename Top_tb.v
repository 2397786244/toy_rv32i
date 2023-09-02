module Top_tb();
reg clk=0;
always #1 clk=~clk;

CPU_Top _inst_cpu_top(
    clk
);
initial begin
        #1000 $finish;
end

initial begin
        $dumpfile("cpu_top.vcd");
        $dumpvars(0,Top_tb);
end

endmodule
