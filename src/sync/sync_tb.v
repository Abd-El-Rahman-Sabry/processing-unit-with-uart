`timescale 1ns/100ps
`include "rst_sync.v"

module tb;

    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 100;

    /*
        cdc-prop {
            cdc-ff-name : rst_sync, 
            cdc-ff-size : 2
        }
    */

    reg tb_clk , tb_rst , tb_async;
    wire tb_sync;

    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;

    rst_sync dut(tb_clk , tb_rst , tb_async , tb_sync);

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
        tb_async <= 1'b0;
    end

    initial 
        begin
            for (integer i = 0; i < RANDOM_STIMULUS_COUNT ; i +=1)
                begin
                    tb_async <= $urandom;
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