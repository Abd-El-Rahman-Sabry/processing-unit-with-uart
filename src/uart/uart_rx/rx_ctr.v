`include "parameters.v"


module rx_ctrl(
    input wire i_clk , i_rst , i_rx , i_par_type, i_en_par ,

    input [3:0] i_bit_cnt,
    input [2:0] i_edge_cnt, 

    // Errors 
    input wire i_par_err, i_stp_err , i_str_err, 
    
    // Enable signals 
    output reg o_en_sample , o_en_cnt , o_en_deser,

    // Enable error checkers 
    output reg o_en_par_chk , o_en_str_chk , o_en_stp_chk,

    // output is valid 

    output reg o_data_valid  

);



    localparam      IDLE    = 3'b000,
                    START   = 3'b001,
                    BYTE    = 3'b010,
                    PARITY  = 3'b011,
                    STOP    = 3'b100,
                    ERROR   = 3'b101; 


    reg [2 : 0]    current_state , next_state;


    wire bit_done , byte_done;

    assign bit_done = &i_edge_cnt;

    assign byte_done = (i_bit_cnt == 4'd9);


    // State register 
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


    // State transition logic 

    always @(*)
        begin
            case (current_state)
                IDLE : 
                    begin
                        next_state <= (~i_rx)? START : IDLE;
                    end 
                START : 
                    begin
                        if(~i_str_err)
                            next_state <= (bit_done)? BYTE: START;
                        else
                            next_state <= ERROR; 
                    end 
                BYTE : 
                    begin
                        if (byte_done)
                            next_state <= (i_en_par)? PARITY : STOP; 
                        else 
                            next_state <= BYTE;
                    end 
                PARITY : 
                    begin
                        if(bit_done)
                            if(~i_par_err)
                                next_state <= STOP;
                            else 
                                next_state <= ERROR;
                        else 
                                next_state <= PARITY;
                    end 
                STOP : 
                    begin

                                if(~i_stp_err )
                                    next_state <= IDLE;
                                else 
                                    next_state <= ERROR;
                             

                    end 
                
                ERROR : 
                    begin
                        next_state <= IDLE;
                    end 
                
                default:
                    begin
                        next_state <= IDLE;
                    end 
            endcase 
        end 


    // State Output 

    always @(*)
        begin
            case (current_state)
                IDLE : 
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b0; 
                        o_en_cnt        <= 1'b0;
                        o_en_deser      <= 1'b0;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b0;
                        o_en_stp_chk    <= 1'b0;
                        o_en_str_chk    <= 1'b0;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b0;
                    end 
                START : 
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b1; 
                        o_en_cnt        <= 1'b1;
                        o_en_deser      <= 1'b0;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b0;
                        o_en_stp_chk    <= 1'b0;
                        o_en_str_chk    <= 1'b1;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b0;
                    end 
                BYTE : 
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b1; 
                        o_en_cnt        <= 1'b1;
                        o_en_deser      <= 1'b1;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b0;
                        o_en_stp_chk    <= 1'b0;
                        o_en_str_chk    <= 1'b0;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b0;
                    end 
                PARITY : 
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b1; 
                        o_en_cnt        <= 1'b1;
                        o_en_deser      <= 1'b0;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b1;
                        o_en_stp_chk    <= 1'b0;
                        o_en_str_chk    <= 1'b0;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b0;
                    end 
                STOP : 
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b1; 
                        o_en_cnt        <= 1'b1;
                        o_en_deser      <= 1'b1;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b0;
                        o_en_stp_chk    <= 1'b1;
                        o_en_str_chk    <= 1'b0;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b1;
                    end 
                
                ERROR : 
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b0; 
                        o_en_cnt        <= 1'b0;
                        o_en_deser      <= 1'b0;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b0;
                        o_en_stp_chk    <= 1'b0;
                        o_en_str_chk    <= 1'b0;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b0;
                    end 
                
                default:
                    begin
                        // Enable Control Signals 
                        o_en_sample     <= 1'b0; 
                        o_en_cnt        <= 1'b0;
                        o_en_deser      <= 1'b0;
                        
                        // Error Control Signals 
                        o_en_par_chk    <= 1'b0;
                        o_en_stp_chk    <= 1'b0;
                        o_en_str_chk    <= 1'b0;
                        
                        // Data Validation signal 
                        o_data_valid    <= 1'b0;
                    end 
            endcase 
        end 


endmodule