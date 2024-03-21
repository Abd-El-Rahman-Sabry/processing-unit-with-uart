`include "parameters.v"

module rx_stp_chk(
    input i_clk , i_rst , i_en_chk, 
    input i_sampled_bit, 
    output reg o_stp_err 
);


    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_stp_err <= 1'b0; 
                end 
            else 
                begin 
                    if(i_en_chk)
                        o_stp_err <= ~i_sampled_bit; 
                    else 
                        o_stp_err <= 1'b0; 
                end  
        end 


endmodule