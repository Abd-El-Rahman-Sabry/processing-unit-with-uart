`include "parameters.v"


module rx_par_chk(
    input wire i_clk , i_rst , i_en_chk, 
    input wire [`WIDTH - 1 : 0] i_data, 
    input wire i_par_type, i_sampled_bit, 

    output reg o_par_err  

);


    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_par_err <= 1'b0; 
                end 
            else 
                begin
                    if(i_en_chk)
                        o_par_err <= (par_calc ^ i_sampled_bit);
                    else 
                        o_par_err <= 1'b0; 
                end 
        end 


    wire par_calc;

    assign par_calc = (i_par_type)? ~(^i_data) : ^i_data;




endmodule 