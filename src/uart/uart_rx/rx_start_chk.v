`include "parameters.v"

module rx_str_chk(
    input i_clk , i_rst , i_en_chk, 
    input i_sampled_bit, 
    output reg o_str_err 
);


    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_str_err <= 1'b0; 
                end 
            else 
                begin 
                    if(i_en_chk)
                        o_str_err <= i_sampled_bit; 
                    else 
                        o_str_err <= 1'b0; 
                end  
        end 


endmodule