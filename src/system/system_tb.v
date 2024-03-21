`timescale 1ns/100ps
`include "system_top.v"

module tb;

    parameter REF_CLK       = 20;
    parameter UART_RX_CLK   = 100;
    parameter UART_TX_CLK   = 800;
    parameter RANDOM_SAMPLE_COUNT = 100;

    reg tb_ref_clk , tb_uart_clk , tb_rst , tb_rx;
    wire tb_tx;

    system_top dut(
        .i_ref_clk(tb_ref_clk),
        .i_uart_clk(tb_uart_clk),
        .i_rst(tb_rst),
        .i_rx(tb_rx),
        .o_tx(tb_tx)
    );

    always #(REF_CLK/2) tb_ref_clk = ~tb_ref_clk;
    always #(UART_RX_CLK/2) tb_uart_clk = ~ tb_uart_clk;

    initial begin
        tb_ref_clk      <= 1'b0;
        tb_uart_clk     <= 1'b0;
        tb_rst          <= 1'b1;
        tb_rx           <= 1'b1;
        handshake_flag  <= 1'b0; 
    end

    task reset;
        begin
            tb_rst <= 1'b1;
            #(0.75*REF_CLK);
            tb_rst <= 1'b0;
            #(0.25*REF_CLK);
            tb_rst <= 1'b1;
        end 
    endtask 


    function [10 : 0] uart_frame;
        input [7:0] data;
        begin
            uart_frame = {1'b1 , ^data , data , 1'b0};
        end 
    endfunction

    task send_frame;
        input [10 : 0] frame; 
        begin
            for (integer  i = 0; i < 11 ; i+=1)
                begin
                    tb_rx <= frame[i];
                    #(UART_TX_CLK);
                end 
        end 
    endtask 

    task rx_frame;
        input [7:0] command; 
        begin
            send_frame(uart_frame(command));
        end 
    
    endtask

    task rf_write_command;
        input [`REG_FILE_ADD_SIZE - 1 : 0]add ; 
        input [`WIDTH - 1 : 0 ] data;
        begin
            rx_frame('haa);
            rx_frame(add);
            rx_frame(data);
        end
    endtask

    task alu_op_command;
        input  [`WIDTH - 1 : 0] op_0 ,op_1;
        input  [`ALU_FUN_WIDTH - 1 : 0] func;
        begin
            rx_frame('hcc);
            rx_frame(op_0);
            rx_frame(op_1);
            rx_frame(func);   
        end     
    endtask

    task alu_nop_command;
        input  [`ALU_FUN_WIDTH - 1 : 0] func;
        begin
            rx_frame('hdd);
            rx_frame(func);   
        end     
    endtask

    task rf_read_command;
        input [`REG_FILE_ADD_SIZE - 1 : 0] add;
        begin
            rx_frame(`RF_R_CMD);
            rx_frame(add);
        end 
    
    endtask 



    //-----------------------------------------------------------------------------|
    // Monitoring -----------------------------------------------------------------|
    //-----------------------------------------------------------------------------|
    reg [10 - 1 : 0] current_value ;
    
    reg handshake_flag; 

    initial
        begin
            #(2*UART_TX_CLK);
            
            for (integer j = 0 ; j < RANDOM_SAMPLE_COUNT ; j +=1)
                begin
                    @(negedge tb_tx);
                    #(0.5*UART_TX_CLK);
                    for (integer i = 0 ;i < 11 ; i += 1)
                        begin
                            current_value[i] <= tb_tx;
                            #(UART_TX_CLK);
                        end 
                    if (~&current_value)
                    $display("%0d " , current_value[8:1]);
                    current_value <= 'b0;
                end 
        end 

    initial
        begin
            $dumpfile("system.vcd");
            $dumpvars;
            // Power on reset
            reset();
            for (integer i = 0 ; i < RANDOM_SAMPLE_COUNT ; i += 1)
                begin
                    
                end 
            $finish;
        end 


endmodule