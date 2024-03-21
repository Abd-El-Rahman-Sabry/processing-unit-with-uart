`include "parameters.v";
module system_ctrl(
    input wire i_clk , i_rst, 
    
    // status siganls 

        // Datapath 
        input wire i_reg_file_valid , i_alu_valid,

        // UART Rx 
        input wire i_rx_valid,

        // UART Tx 
        input wire i_tx_busy, 

        input wire [`WIDTH - 1 : 0] i_rx_data,
         

    // Control singals 
        // Alu 
        output reg o_alu_en , o_ld_alu_func , o_alu_clk_en,
        // RegFile 
        output reg o_en_r , o_en_w , o_ld_rf_data , o_rf_data_source,
        output reg o_ld_rf_add,
        output reg [1:0] o_rf_add_source,

        // Output 
        output reg o_output_source,

        // UART Tx 
        output reg o_tx_valid 

);


    localparam  IDLE        = 4'b0000,
                LD_D_RX     = 4'b0001,
                LD_ALU_OUT  = 4'b0010,
                LD_RF_OUT   = 4'b0011, 
                LD_FUNC     = 4'b0100,
                LD_OP_0     = 4'b0101, 
                LD_OP_1     = 4'b0110, 
                LD_ADD_RX_W = 4'b0111,
                LD_ADD_RX_R = 4'b1000,
                WRITE       = 4'b1001,
                SEND_ALU    = 4'b1010,
                FUNC_NO_OP  = 4'b1011,
                WRITE_ALU   = 4'b1100;

    reg [7:0] current_cmd; 

    reg [3:0] current_state , next_state; 


    // State register 


    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    current_state <= 'b0; 
                end 
            else 
                begin
                    current_state <= next_state; 
                end 
        end

    // Next State logic     

    always @(*)
        case (current_state)
        
        IDLE:
            begin
                if(i_rx_valid)
                    begin
                        case(i_rx_data)
                            `RF_W_CMD   :   next_state <= LD_ADD_RX_W; 
                            `RF_R_CMD   :   next_state <= LD_ADD_RX_R; 
                            `ALU_OP_CMD :   next_state <= LD_OP_0;
                            `ALU_F_CMD  :   next_state <= FUNC_NO_OP;
                            `ALU_W_CMD  :   next_state <= LD_OP_0;
                            default     :   next_state <= IDLE;
                        endcase 
                    end 
                else 
                    next_state <= IDLE;
            end
        
        LD_D_RX:        next_state <= (i_rx_valid)?WRITE : LD_D_RX ;
        LD_FUNC:        next_state <= (i_rx_valid)? LD_ALU_OUT : LD_FUNC;
        FUNC_NO_OP:     next_state <= (i_rx_valid)? LD_ALU_OUT : FUNC_NO_OP;
        LD_ADD_RX_R:    next_state <= (i_rx_valid)?LD_RF_OUT:LD_ADD_RX_R; 
        LD_ADD_RX_W:    next_state <= (i_rx_valid) ? LD_D_RX : LD_ADD_RX_W;
        LD_OP_0:        next_state <= (i_rx_valid) ? LD_OP_1 : LD_OP_0;
        LD_OP_1:        next_state <= (i_rx_valid) ? LD_FUNC : LD_OP_1;
        LD_ALU_OUT:     next_state <= SEND_ALU;
        SEND_ALU:       next_state <= (i_tx_busy)? IDLE : SEND_ALU;
        LD_RF_OUT:      next_state <= (i_tx_busy)? IDLE : LD_RF_OUT;
        WRITE :         next_state <= (1)? IDLE : WRITE;
        WRITE_ALU :     next_state <= IDLE; 
        default :       next_state <= IDLE;
        endcase  



    // State output 

    always @(*)
        begin

        case (current_state)
        IDLE: 
            begin

                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b00;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        LD_D_RX: 
            begin
                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b1;
                o_rf_data_source    <= 1'b1;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end

        LD_ADD_RX_R: 
            begin
                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b1;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b1;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        LD_ADD_RX_W: 
            begin
                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b1;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        LD_OP_0: 
            begin
                o_alu_en            <= 1'b1;
                o_alu_clk_en        <= 1'b1;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b1;
                o_rf_data_source    <= 1'b1;
                o_ld_rf_add         <= 1'b1;
                o_rf_add_source     <= 2'b00;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        LD_OP_1: 
            begin
                o_alu_en            <= 1'b1;
                o_alu_clk_en        <= 1'b1;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b1;
                o_ld_rf_data        <= 1'b1;
                o_rf_data_source    <= 1'b1;
                o_ld_rf_add         <= 1'b1;
                o_rf_add_source     <= 2'b01;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        LD_FUNC: 
            begin
                o_alu_en            <= 1'b1;
                o_alu_clk_en        <= 1'b1;
                o_ld_alu_func       <= 1'b1;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b1;
                o_ld_rf_data        <= 1'b1;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b1;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        FUNC_NO_OP: 
            begin
                o_alu_en            <= 1'b1;
                o_alu_clk_en        <= 1'b1;
                o_ld_alu_func       <= 1'b1;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end
        LD_ALU_OUT:
            begin
                o_alu_en            <= 1'b1;
                o_alu_clk_en        <= 1'b1;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b1;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b1;
                o_rf_add_source     <= 2'b00;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b1;
            end 
        LD_RF_OUT:
            begin
                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b1;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b1;
                o_tx_valid          <= 1'b1;
            end 
        WRITE:
            begin
                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b1;
                o_en_w              <= 1'b1;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b1;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b1;
                o_tx_valid          <= 1'b0;
            end 
        SEND_ALU:
            begin
                o_alu_en            <= 1'b1;
                o_alu_clk_en        <= 1'b1;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b10;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b1;
            end


        default : 
            begin
                o_alu_en            <= 1'b0;
                o_alu_clk_en        <= 1'b0;
                o_ld_alu_func       <= 1'b0;
                
                o_en_r              <= 1'b0;
                o_en_w              <= 1'b0;
                o_ld_rf_data        <= 1'b0;
                o_rf_data_source    <= 1'b0;
                o_ld_rf_add         <= 1'b0;
                o_rf_add_source     <= 2'b00;
                
                o_output_source     <= 1'b0;
                o_tx_valid          <= 1'b0;
            end  
        endcase
    end 

endmodule 