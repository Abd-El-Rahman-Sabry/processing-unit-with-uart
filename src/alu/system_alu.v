`include "parameters.v"

module system_alu (
    input wire i_clk , i_rst, i_en,
    input wire [`WIDTH - 1 : 0] i_a , i_b,
    input wire [`ALU_FUN_WIDTH - 1 : 0] i_func,
    
    output reg o_valid, 
    output reg [`WIDTH - 1 : 0] o_alu_out
);
    

    reg [`WIDTH - 1 : 0] alu_out_com;
    reg alu_valid_flag; 


    always @(posedge i_clk or negedge i_rst) begin

            if(~i_rst)
                begin
                    o_alu_out <= {`WIDTH{1'b0}};
					o_valid <= 1'b0; 
                end
            else
                begin
                    if (i_en)
                        begin
                            o_alu_out   <= alu_out_com;
                            o_valid     <= alu_valid_flag;
                        end
					else 
						o_valid <= 1'b0;
                end 
        
    end


    always @(*)
        begin
            alu_valid_flag <= 1'b1; 
            case (i_func)
                `ADD    : alu_out_com <= i_a + i_b;
                `SUB    : alu_out_com <= i_a - i_b;
                `MUL    : alu_out_com <= i_a * i_b;
                `DIV    : alu_out_com <= i_a / i_b;
                `AND    : alu_out_com <= i_a & i_b;
                `OR     : alu_out_com <= i_a | i_b;
                `NAND   : alu_out_com <= ~(i_a & i_b);
                `NOR    : alu_out_com <= ~(i_a | i_b);
                `XOR    : alu_out_com <= i_a ^ i_b; 
                `XNOR   : alu_out_com <= ~(i_a ^ i_b);
                `EQ     : alu_out_com <= i_a == i_b;
                `GT     : alu_out_com <= i_a > i_b;
                `SHR    : alu_out_com <= i_a >> 1;
                `SHL    : alu_out_com <= i_a << 1;
                default :
                    begin
                        alu_out_com <= {`WIDTH{1'b0}};
                        alu_valid_flag <= 1'b0; 
                    end 
            endcase 
        end 





endmodule