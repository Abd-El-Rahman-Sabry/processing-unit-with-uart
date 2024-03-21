`include "system_alu.v"
`include "system_regfile.v"
`include "system_clk_gate.v"


module system_datapath(
    // Clock and Reset signals 
    input wire i_clk , i_rst ,
    
    // Control singals 
    input wire i_alu_en, i_ld_alu_func, i_alu_clk_en,
    input wire i_rx_data_valid, 
    input wire i_en_r, i_en_w,
    input wire i_ld_rf_data, i_rf_data_source, 
    input wire i_ld_rf_add, 
    input wire [1:0] i_rf_add_source, 

    input wire i_output_source,

    // Receiver input data bus 
    input wire [`WIDTH - 1 : 0] i_rx_data,
    
    // Status signals 
    output wire o_reg_file_valid , o_alu_valid,
    
    // Configuration registers 
    output wire [`WIDTH -1 : 0] o_uart_config , o_clk_div_config,
    // Output data 
    output reg [`WIDTH - 1 : 0] o_tx_data

    
);


    wire alu_gated_clk;

    system_clk_gate u2(
        .i_clk(i_clk),
        .i_en(i_alu_clk_en),
        .o_clk_gated(alu_gated_clk)
    );


    wire [`WIDTH - 1 : 0] alu_op_0 , alu_op_1 , alu_out;

    reg [`ALU_FUN_WIDTH - 1 : 0] func_reg;

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    func_reg <= {`ALU_FUN_WIDTH{1'b0}};
                end 
            else 
                begin
                    if(i_ld_alu_func & i_rx_data_valid)
                        func_reg <= i_rx_data[`ALU_FUN_WIDTH - 1 : 0];
                end 
        end 

    system_alu u0(
        .i_clk(alu_gated_clk),
        .i_rst(i_rst),
        .i_en(i_alu_en),
        .i_a(alu_op_0),
        .i_b(alu_op_1),
        .i_func(func_reg),
        .o_valid(o_alu_valid),
        .o_alu_out(alu_out)
    );


    reg [`WIDTH - 1: 0] data_in_reg; 

    reg [`REG_FILE_ADD_SIZE - 1 : 0] add_in_reg;

    always @(posedge i_clk or negedge i_rst) begin
        if(~i_rst)
            begin
                data_in_reg <= {`WIDTH{1'b0}};
            end 
        else 
            begin
                /*
                    i_rf_data_source values :
                        0 : RF_SOURCE_RX_DATA
                        1 : RF_SOURCE_ALU_OUT
                */ 
                if (i_ld_rf_data & i_rx_data_valid)
                begin
                    data_in_reg <= (i_rf_data_source)? i_rx_data : alu_out;

                end  
            end 
    end

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    add_in_reg <= {`REG_FILE_ADD_SIZE{1'b0}};
                end 
            else  
                begin
                    if(i_ld_rf_add & i_rx_data_valid)
                        begin
                            case(i_rf_add_source)
                                `RF_ADD_OP_0    : add_in_reg <= 'b0;
                                `RF_ADD_OP_1    : add_in_reg <= 'b1;
                                `RF_ADD_RX_DATA : add_in_reg <= i_rx_data[`REG_FILE_ADD_SIZE - 1 : 0];
                                default         : add_in_reg <= 'b0;
                            endcase 
                        end 
                end 
        end 


    wire [`WIDTH - 1 : 0] reg_file_out;

    system_regfile u1(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(data_in_reg),
        .i_add(add_in_reg),
        .i_en_w(i_en_w),
        .i_en_r(i_en_r),

        .o_data(reg_file_out),
        .o_valid(o_reg_file_valid),

        .o_reg_0(alu_op_0),
        .o_reg_1(alu_op_1),
        .o_reg_2(o_uart_config),
        .o_reg_3(o_clk_div_config)
    );

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_tx_data <= {`WIDTH{1'b0}};
                end 
            else 
                begin
                    o_tx_data <= (i_output_source)?reg_file_out:alu_out; 
                end 
        end 

endmodule