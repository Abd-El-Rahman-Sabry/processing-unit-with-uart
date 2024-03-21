`timescale 1ns/100ps
`include "data_sync.v"

module tb;

    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 100;


    reg tb_clk , tb_rst , tb_en_async;
    reg [`WIDTH - 1 : 0] tb_async_data;
    wire tb_sync;
    wire [`WIDTH - 1 : 0] tb_sync_data;

    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;

    system_data_sync dut(tb_clk , tb_rst , tb_async_data ,tb_en_async, tb_sync_data ,tb_sync);

    task reset;
        begin
            tb_rst <= 1'b1;
            #(0.75*CLK_CYCLE);
            tb_rst <= 1'b0;
            #(0.275*CLK_CYCLE);
            tb_rst <= 1'b1;
        end 
    endtask 

    initial begin
        tb_clk <= 1'b0;
        tb_rst <= 1'b1;
        tb_en_async <= 1'b0;
        tb_async_data <= 'b0;
    end

    initial 
        begin
            for (integer i = 0; i < RANDOM_STIMULUS_COUNT ; i +=1)
                begin
                    tb_en_async <= 1;
                    tb_async_data <= $urandom;
                    #(CLK_CYCLE);
                    tb_en_async = 0;
                    #(($urandom % 10) * CLK_CYCLE);
                end 
        end 

    initial
        begin
            $dumpfile("design.vcd");
            $dumpvars;
            reset();
            #(10000 * CLK_CYCLE);
            $finish; 
        end 




endmodule 