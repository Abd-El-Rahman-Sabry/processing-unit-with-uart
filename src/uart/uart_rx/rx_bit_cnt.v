`include "parameters.v"


module rx_edge_bit_cnt(
    input wire i_clk , i_rst , i_en_cnt, 
    output reg [3:0] o_bit_cnt,
    output reg [2:0] o_edge_cnt 
);
    

    wire bit_cnt_done;

    reg [3:0] bit_cnt_comb;
    reg [2:0] edge_cnt_comb;


    always @(posedge i_clk or negedge i_rst) begin
        if(~i_rst)
            begin
                o_edge_cnt <= 3'b0; 
            end 
        else 
            begin
                if(i_en_cnt)
                    begin
                        o_edge_cnt <= edge_cnt_comb;
                    end 
                else 
                    begin
                        o_edge_cnt <= 3'b0; 
                    end 
            end 
        
    end


    always @(*)
        begin
            edge_cnt_comb <= o_edge_cnt + 1'b1;
        end 


    assign bit_cnt_done = (o_edge_cnt == 3'b111);


    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_bit_cnt <= 4'b0; 
                end 
            else 
                begin
                    if(i_en_cnt)
                        begin
                            o_bit_cnt <= bit_cnt_comb;
                        end 
                    else 
                        begin
                            o_bit_cnt <= 4'b0;
                        end 
                end 
        end 

    always @(*)
        begin
            if(bit_cnt_done)
                bit_cnt_comb <= o_bit_cnt + 1'b1;
            else  
                bit_cnt_comb <= o_bit_cnt;  
        end 



endmodule