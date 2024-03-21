`timescale 1ns/100ps

`include "system_alu.v"
`include "parameters.v"


module tb;

    parameter CLK_CYCLE = 2;
    parameter RANDOM_STIMULUS_COUNT = 10000;

    reg tb_clk , tb_rst, tb_en;
    reg [`WIDTH - 1 : 0] tb_a , tb_b;
    reg [`ALU_FUN_WIDTH - 1 : 0] tb_func;
    
    wire tb_valid; 
    wire [`WIDTH - 1 : 0] tb_alu_out;


    alu dut(
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_en(tb_en),
        .i_a(tb_a),
        .i_b(tb_b),
        .i_func(tb_func),
        .o_valid(tb_valid),
        .o_alu_out(tb_alu_out)
    );

    always #(CLK_CYCLE/2) tb_clk = ~tb_clk;

    function [`WIDTH - 1 : 0] alu_model;
        
        input  [`WIDTH - 1 : 0] a , b;
        
        input  [`ALU_FUN_WIDTH - 1 : 0] f; 
        
        begin
                case (f)
                `ADD    : alu_model = a + b;
                `SUB    : alu_model = a - b;
                `MUL    : alu_model = a * b;
                `DIV    : alu_model = a / b;
                `AND    : alu_model = a & b;
                `OR     : alu_model = a | b;
                `NAND   : alu_model = ~(a & b);
                `NOR    : alu_model = ~(a | b);
                `XOR    : alu_model = a ^ b; 
                `XNOR   : alu_model = ~(a ^ b);
                `EQ     : alu_model = a == b;
                `GT     : alu_model = a > b;
                `SHR    : alu_model = a >> 1;
                `SHL    : alu_model = a << 1;
                default :
                    begin
                        alu_model = {`WIDTH{1'b0}};
                    end 
            endcase 
        end 
        
    endfunction


    // Stats 

    integer count_valid = 0;
    integer count_fail = 0;

    task transaction;
        input [`WIDTH - 1 : 0] a , b;
        input [`ALU_FUN_WIDTH - 1 : 0] f; 

        begin
            tb_a <= a;
            tb_b <= b;
            tb_func <= f;

            #CLK_CYCLE;
            if (alu_model(a , b , f ) == tb_alu_out)
               begin 
                    $display("-------------------Valid-------------");
                    count_valid += 1;
               end 
            else 
                begin
                    $display("-------------------Fail--------------");
                    count_fail += 1;
                end 
            $display("A = %0d , B = %0d , Function = %0d , results = %0d" , a , b , f , tb_alu_out);
            $display("-------------------------------------");

        end 
    
    endtask 

    initial
        begin
            tb_clk  <= 1'b0;
            tb_rst  <= 1'b1;
            tb_en   <= 1'b1;
        end 

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
        $dumpfile("design.vcd");
        $dumpvars;
        reset();

        for (integer  i = 0 ; i < RANDOM_STIMULUS_COUNT ; i +=1 )
        begin
            transaction(
                $urandom % 2**(`WIDTH / 2),
                $urandom % 2**(`WIDTH / 2),
                $urandom % 2**(`ALU_FUN_WIDTH)
            );
        end 
        
        $display("Test is done !!!");
        $display("Stats -----------------");
        $display("Total Valid Cases = %0d" , count_valid);
        $display("Total Wrong Cases = %0d" , count_fail);
        $display("-----------------------");
        $finish;
        
    end
    


endmodule 
