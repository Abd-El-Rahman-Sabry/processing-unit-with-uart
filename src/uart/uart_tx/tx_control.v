`include "parameters.v"


module tx_ctrl(
    input wire i_clk , i_rst , i_data_valid, i_en_par, i_ser_done,
    output reg o_busy , o_ser_en,
    output reg [1:0] o_mux_sel
);


localparam  IDLE            = 3'b000, 
            START           = 3'b001,
            SER_BYTE        = 3'b010, 
            PAR             = 3'b011,
            STOP            = 3'b111;


reg [2 : 0] current_state , next_state;


always @(posedge i_clk or negedge i_rst)
    begin
        if(~i_rst)
            begin
                current_state <= IDLE;
            end 
        else 
            begin
                current_state <= next_state;
            end 
    end 


// Next State Logic 

    always @(*)
        begin
            case (current_state)
                IDLE        : next_state <= (i_data_valid)? START : IDLE;
                START       : next_state <= SER_BYTE;
                SER_BYTE    : 
                        begin
                            if(!i_ser_done)
                                next_state <= SER_BYTE;
                            else
                                next_state <= (i_en_par)?PAR:STOP;
                                
                        end
                PAR         : next_state <= STOP;
                STOP        : next_state <= IDLE; 

                default     : next_state <= IDLE;
                
            endcase 
        end 


// State Output 

    always @(*)
        begin
            case (current_state)
                IDLE:
                    begin
                        o_ser_en    <= 1'b0;
                        o_busy      <= 1'b0;
                        o_mux_sel   <= 2'b11;
                    end
                START:
                    begin
                        o_ser_en    <= 1'b0;
                        o_busy      <= 1'b1;
                        o_mux_sel   <= 2'b00;
                    end
                SER_BYTE:
                    begin
                        o_ser_en    <= 1'b1;
                        o_busy      <= 1'b1;
                        o_mux_sel   <= 2'b01;
                    end
                PAR:
                    begin
                        o_ser_en    <= 1'b0;
                        o_busy      <= 1'b1;
                        o_mux_sel   <= 2'b10;
                    end
                STOP:
                    begin
                        o_ser_en    <= 1'b0;
                        o_busy      <= 1'b1;
                        o_mux_sel   <= 2'b11;
                    end
                default:
                    begin
                        o_ser_en    <= 1'b0;
                        o_busy      <= 1'b0;
                        o_mux_sel   <= 2'b0;
                    end 
            endcase 
        end 

endmodule 