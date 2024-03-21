`include "parameters.v"

module rx_deser(
    input wire i_clk , i_rst , i_en_deser, 
    input [2:0] i_edge_cnt, 
    input wire i_sampled_bit, 

    output reg [`WIDTH - 1 : 0] o_data 
);

    reg [`WIDTH - 1 : 0] data_comb; 

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_data <= {`WIDTH{1'b0}}; 
                end  
            else 
                begin
                    if(i_en_deser & (&i_edge_cnt))
                        o_data <= data_comb;
                    else 
                        o_data <= o_data; 

                end 
        end 

    always @(*)
        begin
            data_comb <= {i_sampled_bit , o_data[7:1]}; 
        end 



endmodule