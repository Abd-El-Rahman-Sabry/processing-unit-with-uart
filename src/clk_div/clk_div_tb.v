`timescale 1ns/100ps

`include "system_clk_div.v"

module tb;
    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 100;

    reg tb_clk , tb_rst;
    reg [4:0] tb_clk_div; 

    wire tb_o_clk;

    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;

    system_clk_div dut(tb_clk , tb_rst , tb_clk_div , tb_o_clk);


    task reset;
        begin
            tb_rst <= 1'b1;
            #(0.75*CLK_CYCLE);
            tb_rst <= 1'b0;
            #(0.25*CLK_CYCLE);
            tb_rst <= 1'b1;
        end 
    endtask 


    initial begin
        tb_clk <= 1'b0;
        tb_rst <= 1'b1;
        tb_clk_div <= 5'd8; 
    end


    initial
        begin
            $dumpfile("design.vcd");
            $dumpvars;
            reset();
            $display("Starting Test");
            
            for (integer  i = 0; i < RANDOM_STIMULUS_COUNT ; i +=1 )
                begin
                    tb_clk_div = 3;
                    #(3 * tb_clk_div * CLK_CYCLE);
                end 
            $finish;
        end 

    


endmodule