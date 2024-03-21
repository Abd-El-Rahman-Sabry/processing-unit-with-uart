`include "parameters.v"


module serializer

(
    input wire i_clk , i_rst, i_en, i_data_valid , i_busy,
    input wire [`WIDTH - 1 : 0 ] i_data, 
    output wire o_ser_out, 
    output wire o_done
);


    localparam COUNTER_WIDTH = $clog2(`WIDTH);
    
    reg [COUNTER_WIDTH - 1 : 0] counter_reg;
    reg [COUNTER_WIDTH : 0] counter_comb;

    reg [`WIDTH - 1 : 0] shift_reg , shift_comb;


    // Shift register 

    always @(posedge i_clk or negedge i_rst) begin
        if(~i_rst)
            begin
                shift_reg <= {`WIDTH{1'b0}};
            end
        else 
            begin
                if (i_data_valid && !i_busy)
                    begin
                        shift_reg <= i_data; 
                    end 
                else 
                    begin
                        if (i_en)
                            shift_reg   <= shift_comb;
                    end 
                    
            
            end 
        
    end

    // Counter register 

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    counter_reg <= {COUNTER_WIDTH{1'b0}};
                end 
            else 
                begin
                    if(i_en && !o_done)
                        counter_reg <= counter_comb;
                    else
                        counter_reg <= {COUNTER_WIDTH{1'b0}};
                end 
        end  

    // Decrement in the counter 
    always @(*)
        begin
            counter_comb = counter_reg + 1'b1; 
        end 

    // Shift logic 
    always @(*)
        begin
            shift_comb = shift_reg >> 1;
        end 

    assign o_ser_out = shift_reg[0];
    assign o_done = counter_comb[COUNTER_WIDTH];


endmodule