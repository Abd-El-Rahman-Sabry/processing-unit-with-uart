`include "uart_tx/system_uart_tx.v"
`include "uart_rx/system_uart_rx.v"

module system_uart (
    input wire i_clk , i_tx_clk, i_rst , i_rx ,
    input wire i_sync_sig, 
    input wire [`WIDTH - 1 : 0] i_sync_data , i_config, 
    
    output wire o_tx, o_tx_busy, 
    
    output wire [`WIDTH - 1 : 0] o_sync_data,
    output wire o_sync_sig 
    
);

    system_uart_tx u0(
        .i_clk(i_tx_clk),
        .i_rst(i_rst),
        .i_data_valid(i_sync_sig),
        .i_data(i_sync_data),
        .i_par_type(i_config[1]),
        .i_en_par(i_config[0]),

        .o_tx(o_tx),
        .o_busy(o_tx_busy)

    );

    system_uart_rx u1(
        .i_clk(i_clk), 
        .i_rst(i_rst),
		.i_rx(i_rx),
        .i_en_par(i_config[0]),
        .i_par_type(i_config[1]),
        .i_prescale(i_config[6:2]),
        .o_data_valid(o_sync_sig),
        .o_data(o_sync_data)
		
    );


    
endmodule