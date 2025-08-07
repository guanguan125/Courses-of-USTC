`timescale 10ns/1ns
module FPGA_EXP5_tb();
    reg res, clk;
    wire [7:0] sin_data;
    always begin
        #0 res = 0; // 初始化复位信号为0
        #2 res = 1; // 2纳秒后释放复位
        clk = 0; // 初始化时钟信号为0
        forever #(1) clk = ~clk; // 每1纳秒翻转时钟信号
    end
    FPGA_EXP5 U1(res, clk, sin_data); // 实例化FPGA_EXP5模块
endmodule