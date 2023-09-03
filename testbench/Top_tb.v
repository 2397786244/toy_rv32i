module Top_tb();
reg clk=0;
reg rst_n=1;
always #2 clk=~clk;

CPU_Top _inst_cpu_top(
    clk,
    rst_n
);
initial begin
        rst_n <= 0;
        #2 rst_n <= 1;
        #1000 $finish;
end

initial begin
        $dumpfile("cpu_top.vcd");
        $dumpvars(0,Top_tb);
end

endmodule
