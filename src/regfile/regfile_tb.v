`timescale 1ns/100ps

`include "parameters.v"
`include "system_regfile.v"



module tb;

    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 10000;


    reg tb_clk , tb_rst;
    
    reg [`WIDTH - 1 : 0] tb_i_data;
    reg [`REG_FILE_ADD_SIZE - 1 : 0] tb_add;
    
    reg tb_en_w , tb_en_r; 


    wire [`WIDTH - 1 : 0] tb_o_data;
    wire tb_vaild;

    wire [`WIDTH - 1 : 0] tb_reg_0 , tb_reg_1 , tb_reg_2 , tb_reg_3; 


    regfile dut(
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_en_r(tb_en_r),
        .i_en_w(tb_en_w),
        .i_data(tb_i_data),
        .i_add(tb_add),

        .o_data(tb_o_data),
        .o_vaild(tb_vaild),
        .o_reg_0(tb_reg_0),
        .o_reg_1(tb_reg_1),
        .o_reg_2(tb_reg_2),
        .o_reg_3(tb_reg_3)
    );




    always #(CLK_CYCLE /2) tb_clk = ~tb_clk;
    

    task reset;
        begin
            tb_rst <= 1'b1;
            #(0.75*CLK_CYCLE);
            tb_rst <= 1'b0;
            #(0.25*CLK_CYCLE);
            tb_rst <= 1'b1;
        end 
        
    endtask


    reg [`WIDTH - 1 : 0] model [0 : `REG_FILE_SIZE - 1];


    task write_data;
        input [`WIDTH - 1 : 0] data;
        input [`REG_FILE_ADD_SIZE : 0] add;

        begin

            model[add] <= data; 
            tb_en_w     <= 1'b1;
            tb_i_data   <= data;
            tb_add      <= add; 

            #(CLK_CYCLE);

            tb_en_w <= 1'b0;
        end 
    endtask 

    // Stats 
    integer count_valid = 0;
    integer count_fails = 0;
    task read_data;
        input [`REG_FILE_ADD_SIZE - 1 : 0] add;

            begin
                tb_en_r     <= 1'b1;
                tb_add      <= add;
                #CLK_CYCLE;
                if (tb_o_data == model[add])
                    begin 
                        $display("------------------Valid------------------");
                        count_valid += 1;
                    end  
                else 
                    begin 
                        $display("------------------Fail-------------------");
                        count_fails += 1;
                    end 

                $display("Location : %0h ,, has a value of %0h ,, Expected : %0h" , add , tb_o_data , model[add]);
                $display("------------------------------------------------");
            end 
    endtask

    initial
        begin
            tb_clk <= 1'b0;
            tb_rst <= 1'b1;
            tb_en_w <= 1'b0;
            tb_en_r <= 1'b0;

            for (integer i = 0 ; i < `REG_FILE_SIZE ; i+= 1)
                begin
                    model[i] <= {`WIDTH{1'b0}};
                end 
        end 


    initial begin
        $dumpfile("design.vcd");
        $dumpvars;
        reset();
            for(integer i = 0 ; i < RANDOM_STIMULUS_COUNT ; i += 1)
                begin
                    write_data(
                        $urandom % 2**(`WIDTH),
                        $urandom % 2**(`REG_FILE_ADD_SIZE)
                    );

                    read_data(
                        $urandom % 2**(`REG_FILE_ADD_SIZE)
                    );
                end
        $display("Test is done ");
        $display("Stats ------------------");
        $display("Valid Cases = %0d" , count_valid);
        $display("Wrong Cases = %0d" , count_fails);
        $display("------------------------");

        $finish;
    end


endmodule 