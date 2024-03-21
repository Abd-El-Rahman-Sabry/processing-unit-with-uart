`timescale 1ns/100ps

`include "tx_serializer.v"
`include "parameters.v"


module tb;
    
    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 100;


    reg  tb_clk , tb_rst, tb_en , tb_data_valid , tb_busy; 
    reg  [`WIDTH - 1 : 0 ] tb_data; 
    wire tb_ser_out;
    wire tb_done;

    serializer dut(
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_en(tb_en),
        .i_data(tb_data),
        .i_data_valid(tb_data_valid),
        .i_busy(tb_busy),
        .o_ser_out(tb_ser_out),
        .o_done(tb_done)
    );


    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;
    
    task serialize;
        input [`WIDTH - 1 : 0] data;
        
        begin
            tb_data_valid <= 1'b1; 
            tb_busy <= 1'b0;
            #CLK_CYCLE;
            tb_busy <= 1'b1;
            tb_en <= 1'b1;
            tb_data <= data;
            @(posedge tb_done);

        end 
    endtask 

    task reset;
        begin
            tb_rst <= 1'b1;
            #(0.75*CLK_CYCLE);
            tb_rst <= 1'b0;
            #(0.25*CLK_CYCLE);
            tb_rst <= 1'b1;
        end 
    endtask 

    initial
        begin
            tb_clk <= 1'b0;
            tb_rst <= 1'b1; 
            tb_en  <= 1'b0;
            tb_data_valid <= 1'b0;
            tb_busy <= 1'b0;
            tb_data <= 'b0;
        end 

    initial begin
        $dumpfile("design.vcd");
        $dumpvars;
        reset();

        for(integer  i = 0; i < RANDOM_STIMULUS_COUNT ; i+=1)
            begin
                serialize(
                    $urandom % 2**(`WIDTH)
                );
            end 

        $finish; 
    end

endmodule