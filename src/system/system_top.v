`include "parameters.v"
`include "system_datapath.v"
`include "system_ctrl.v"
`include "system_uart.v"
`include "system_clk_div.v"
`include "rst_sync.v"
`include "data_sync.v"


module system_top(
    input wire i_ref_clk , i_uart_clk , i_rst, i_rx,
    output wire o_tx
);

    // Clock domain 1 rst
    
    wire ref_rst, uart_rst;

    system_rst_sync u0(
        .i_clk(i_ref_clk),
        .i_rst(i_rst),
        .i_async(1'b1),
        .o_sync(ref_rst)
    );

    // Clock domain 2 rst

    system_rst_sync u1(
        .i_clk(i_uart_clk),
        .i_rst(i_rst),
        .i_async(1'b1),
        .o_sync(uart_rst)
    );

    // Rx received data sync 

    wire [`WIDTH - 1 : 0] async_rx_data , sync_rx_data;
    wire async_rx_signal , sync_rx_signal; 

    system_data_sync u2(
        .i_clk(i_ref_clk),
        .i_rst(ref_rst),
        .i_async_data(async_rx_data),
        .i_async_en(async_rx_signal),

        .o_sync_data(sync_rx_data),
        .o_sync_en(sync_rx_signal)
    );

    // Tx transmission data sync 

    wire [`WIDTH - 1: 0] async_tx_data , sync_tx_data;
    wire async_tx_signal , sync_tx_signal; 

    system_data_sync u3(
        .i_clk(tx_clk),
        .i_rst(uart_rst),
        .i_async_data(async_tx_data),
        .i_async_en(async_tx_signal),

        .o_sync_data(sync_tx_data),
        .o_sync_en(sync_tx_signal)
    );

    wire [`WIDTH - 1 : 0] uart_config , clk_div_config;

    // Register file nets 
    wire rf_en_r , rf_en_w , rf_ld_data , rf_data_source;
    wire [1:0] rf_add_source;
    wire rf_ld_add;

    wire reg_file_valid;

    // ALU nets 
    wire alu_en , alu_ld_func_en , alu_clk_en , alu_valid;

    // Output 

    wire out_source;
    
    system_datapath u4(
        .i_clk(i_ref_clk),
        .i_rst(ref_rst),
        
        .i_alu_en(alu_en),
        .i_alu_clk_en(alu_clk_en),
        .i_ld_alu_func(alu_ld_func_en),
        
        .i_en_r(rf_en_r),
        .i_en_w(rf_en_w),
        .i_ld_rf_data(rf_ld_data),
        .i_rf_data_source(rf_data_source),
        .i_ld_rf_add(rf_ld_add),
        .i_rf_add_source(rf_add_source),
        .i_output_source(out_source),

        .i_rx_data(sync_rx_data),
        .i_rx_data_valid(sync_rx_signal),

        .o_reg_file_valid(reg_file_valid),
        .o_alu_valid(alu_valid),
        .o_uart_config(uart_config),
        .o_clk_div_config(clk_div_config),

        .o_tx_data(async_tx_data)
    );

    system_ctrl u5(
        .i_clk(i_ref_clk),
        .i_rst(ref_rst),
        .i_reg_file_valid(reg_file_valid),
        .i_alu_valid(alu_valid),
        
        .i_rx_valid(sync_rx_signal),
        .i_tx_busy(tx_busy),
        .i_rx_data(sync_rx_data),

        .o_alu_en(alu_en),
        .o_ld_alu_func(alu_ld_func_en),
        .o_alu_clk_en(alu_clk_en),
        .o_en_r(rf_en_r),
        .o_en_w(rf_en_w),
        .o_ld_rf_data(rf_ld_data),
        .o_rf_data_source(rf_data_source),
        .o_ld_rf_add(rf_ld_add),
        .o_rf_add_source(rf_add_source),

        .o_output_source(out_source),

        .o_tx_valid(async_tx_signal)

    );

    wire tx_clk;

    system_clk_div u6(
        .i_clk(i_uart_clk),
        .i_rst(uart_rst),
        .i_div_ratio(clk_div_config[4:0]),
        .o_clk(tx_clk)
    );

    wire tx_busy;
    system_uart u7(
        .i_clk(i_uart_clk),
        .i_tx_clk(tx_clk),
        .i_rst(uart_rst),
        
        .i_sync_sig(sync_tx_signal),
        .i_sync_data(sync_tx_data),

        .i_config(uart_config),

        // UART Transmission singals 
        .i_rx(i_rx),
        .o_tx(o_tx),
        .o_tx_busy(tx_busy),

        .o_sync_data(async_rx_data),
        .o_sync_sig(async_rx_signal)

    );

endmodule