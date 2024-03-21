`timescale 1ns/100ps

`include "system_uart_tx.v"


module tb;

    parameter   CLK_CYCLE = 2;
    parameter   RANDODM_STIMULUS_COUNT = 10000;

    reg tb_clk , tb_rst , tb_data_valid; 
    reg[`WIDTH - 1 : 0] tb_data;

    // Configuration 

    reg tb_par_type , tb_en_par; 

    wire tb_tx , tb_busy ;

    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;
    uart_tx dut(
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_data_valid(tb_data_valid),
        .i_data(tb_data),
        .i_par_type(tb_par_type),
        .i_en_par(tb_en_par),
        .o_tx(tb_tx),
        .o_busy(tb_busy)
    );

    localparam FRAME_SIZE = `WIDTH + 3;

    // Stats 

    integer count_valid_frames = 0;
    integer count_fail_frames = 0;

    reg [FRAME_SIZE - 1 : 0] frame , golden_frame; 

    task send_data;
        input [`WIDTH - 1 : 0] data;

        begin
            tb_data <= data;
            tb_data_valid <= 1'b1; 
            frame <= 'b0;
            golden_frame <= 'b0;
            @(posedge tb_busy);
            #CLK_CYCLE;
            for (integer  i = 0; i < `WIDTH + 3 ; i+=1)
                begin 
                    frame[i] = tb_tx;
                    #CLK_CYCLE;
                end

            @(negedge tb_busy);

            if (tb_en_par)
                begin
                    if (tb_par_type)
                        golden_frame = {1'b1 , ~(^data), data , 1'b0};
                    else 
                        golden_frame = {1'b1 , (^data), data , 1'b0};
                end 
            else 
                begin
                    golden_frame = {2'b11 , data , 1'b0};
                end 

            if (golden_frame == frame)
                begin
                    $display("-------------------------Valid----------------------------");
                    count_valid_frames += 1;
                end 
            else 
                begin
                    $display("-------------------------Fail----------------------------");
                    count_fail_frames += 1;
                end 

            $display("Expected Frame = {%0b} , Sampled Frame {%0b}" , golden_frame , frame);
            $display("Given Configuration : parity enabled : %0d ,  parity type : %d" , tb_en_par , tb_par_type);
            $display("----------------------------------------------------------------------");
                         
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
            tb_par_type <= 1'b1;
            tb_en_par   <= 1'b1;
            tb_data     <= 'b0;
            tb_data_valid   <= 1'b0;
        end 



    initial begin
         $dumpfile("tx.vcd");
         $dumpvars;
         reset();

        for (integer i = 0 ; i< RANDODM_STIMULUS_COUNT ; i+= 1)
            begin
                tb_par_type <= $urandom % 2;
                tb_en_par   <= $urandom % 2;
                send_data(
                    $urandom % 2**(`WIDTH)
                );
            end 
        
        $display("UART TX test is done");
        $display("Stats =======================");
        $display("Passed Frames = %0d" , count_valid_frames);
        $display("Failed Frames = %0d" , count_fail_frames);
        $display("=============================");
         $finish;
    end
    



endmodule