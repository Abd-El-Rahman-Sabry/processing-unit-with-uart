module system_clk_div(
    input wire i_clk, i_rst, 
    input wire [4 : 0]  i_div_ratio,
    output reg o_clk  
);


    always @(posedge i_clk or negedge i_rst ) begin
        if(~i_rst)
            begin
                o_clk <= 1'b0;
            end 
        else 
            begin
                if (cnt_center | cnt_done )
                    begin
                        o_clk <= ~o_clk;
                    end
            end 
    end


    // 

    reg [4:0] cnt , cnt_comb; 
    
    wire cnt_done , cnt_center; 
    assign cnt_done = (cnt_comb == (i_div_ratio));

    assign cnt_center = (cnt_comb == (i_div_ratio >> 1));

    always @ (posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    cnt <= 5'b0; 
                end 

            else 
                begin
                    if (cnt_done)
                        cnt <= 5'b0; 
                    else 
                        cnt <= cnt_comb; 
                end 
        end 

    always @(*)
        begin
            cnt_comb <= cnt + 1'b1; 
        end 

    

endmodule 