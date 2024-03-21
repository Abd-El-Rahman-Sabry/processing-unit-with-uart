`timescale 1ns/100ps

`include "system_uart_rx.v"

module tb;
    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 10000;

    // Clock Generation 

    reg tb_clk , tb_rst , tb_rx;
    reg tb_par_type , tb_en_par;
    reg [4:0] tb_prescale;

    wire tb_data_valid;
    wire [`WIDTH - 1 : 0] tb_data;


    uart_rx dut(
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_rx(tb_rx),
        .i_par_type(tb_par_type),
        .i_en_par(tb_en_par),
        .i_prescale(tb_prescale),
        .o_data_valid(tb_data_valid),
        .o_data(tb_data)
    );



    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;


    task reset;
        begin
            tb_rst <= 1'b1;
            #(0.75*CLK_CYCLE);
            tb_rst <= 1'b0;
            #(0.25*CLK_CYCLE);
            tb_rst <= 1'b1;

        end 
    endtask 

    integer frame_size = 0;

    localparam FRAME_SIZE = `WIDTH + 3;

    reg [FRAME_SIZE - 1 : 0] frame;

    reg [`WIDTH - 1 : 0] current_data_buffer; 


    // Driver 
    task receive_byte;
        input [`WIDTH - 1 : 0] byte; 
        begin

            frame_size = (tb_en_par)?FRAME_SIZE : (FRAME_SIZE - 1);
            current_data_buffer = byte;

            if (tb_en_par)
                begin
                    if (tb_par_type)
                        frame = {1'b1, ~^byte , byte , 1'b0};
                    else 
                        frame = {1'b1, ^byte , byte , 1'b0};
                end 
            else 
                frame = {1'b1 , byte , 1'b0};
                
            for(integer i = 0 ; i < frame_size ; i += 1 )
                begin
                    tb_rx = frame[i];
                    #(8*CLK_CYCLE);
                end 

        end 

    endtask 

    // Scoreboard 

    integer passed_case = 0;
    integer failed_case = 0;


    // Monitor 

    initial
        begin
            for (integer i = 0 ; i < RANDOM_STIMULUS_COUNT ; i += 1)
                begin
                    @(posedge tb_data_valid);

                    if (current_data_buffer == tb_data)
                        begin
                            $display("---------------Valid---------------");
                            passed_case +=1;
                        end 
                    else 
                        begin
                            $display("---------------Fail----------------");
                            failed_case +=1;
                        end 
                    $display("Received Byte = %0b , Expected = %0b" , tb_data , current_data_buffer);
                    $display("Givn Configurations ,,parity enabled : %0d ,, parity type : %0d" , tb_en_par , tb_par_type);
                    $display("----------------------------------------------");
                end 
        end 

    initial
        begin
            tb_clk <= 1'b0;
            tb_rst <= 1'b1;
            tb_rx  <= 1'b1;
            tb_prescale <= 5'd8;
            tb_par_type <= 1'b0;
            tb_en_par   <= 1'b1;

        end 


    initial begin
        $dumpfile("rx.vcd");
        $dumpvars;

        // power on reset 
        reset();

        #(CLK_CYCLE);
        for (integer i = 0 ; i < RANDOM_STIMULUS_COUNT ; i+= 1)
            begin
                tb_par_type = $urandom;
                tb_en_par = $urandom;
                receive_byte(
                    $urandom % 2 ** (`WIDTH)
                );
            end 
        

        $display("UART RX Test");
        $display("Stats ----------------");
        $display("Passed Cases : %0d" , passed_case);
        $display("Failed Cases : %0d" , failed_case);
        $display("-----------------------");
        $finish;
    end

endmodule