module system_clk_gate(
    input wire i_en , i_clk,
    output wire o_clk_gated 
);

    reg latch_out; 
    

    assign o_clk_gated = i_clk & latch_out;

    always @(i_clk or i_en) begin
        if(~i_clk)
            latch_out <= i_en;       
    end


endmodule 