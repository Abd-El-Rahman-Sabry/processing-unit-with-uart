`include "parameters.v"

module rx_data_sample(
    input wire          i_clk , i_rst , i_rx, i_en_samp, 
    input wire [4:0]    i_prescale, 
    input wire [2:0]    i_edge_cnt, 

    output reg o_sampled_bit 
);


    // Samples indeces 
    wire [2:0] left , center , right;

    assign center = i_prescale >> 2 - 1'b1;
    assign left = center - 1'b1;
    assign right = center + 1'b1; 



    reg [1:0] samples;

    // Sampling 
    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                     samples <= 2'b0;
                end 
            else 
                begin
                    if (i_en_samp)
                        if(i_edge_cnt == left)
                            samples[0] <= i_rx; 
                        else if (i_edge_cnt == center)
                            samples[1] <= i_rx;
                        else if (i_edge_cnt == right)
                            samples[2] <= i_rx;
                    else 
                        samples <= 3'b0;  
                end 
        end 

    wire all_ones , all_zeros , even_ones;

    assign all_ones = &samples;
    assign all_zeros = ~(|samples);
    assign even_ones = ^samples;


    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_sampled_bit <= 1'b0;  
                end 
            else 
                begin 
                    if(i_en_samp)
                        begin
                            if((even_ones && (~all_zeros)) | all_ones)
                                o_sampled_bit <= 1'b1;
                            else 
                                o_sampled_bit <= 1'b0; 
                        end 
                    else 
                        o_sampled_bit <= 1'b0; 
                end  
        end 

    




endmodule 