`include "tx_control.v"
`include "tx_mux.v"
`include "tx_parity.v"
`include "tx_serializer.v"


module system_uart_tx(
    input wire i_clk , i_rst , i_data_valid, 
    input wire [`WIDTH - 1 : 0] i_data, 

    // Configuration 

    input wire i_par_type , i_en_par, 

    output wire o_tx , o_busy 

);

    wire ser_bit;
    wire ser_en;
    wire ser_done;

    serializer u0 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data_valid(i_data_valid),
        .i_busy(o_busy),
        .i_data(i_data),
        .i_en(ser_en),
        .o_ser_out(ser_bit),
        .o_done(ser_done)
    );


    tx_ctrl u1(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data_valid(i_data_valid),
        .i_en_par(i_en_par),
        .i_ser_done(ser_done),
        .o_busy(o_busy),
        .o_ser_en(ser_en),
        .o_mux_sel(mux_sel)
    );
    
    wire par_bit;

    tx_partiy_calc u2(
        .i_data(i_data),
        .i_type(i_par_type),
        .o_parity(par_bit)
    );

    wire [1:0] mux_sel;

    tx_mux u3(
        .i_start_bit(1'b0),
        .i_ser_bit(ser_bit),
        .i_par_bit(par_bit),
        .i_stop_bit(1'b1),
        .i_sel(mux_sel),
        .o_ser_out(o_tx)
    );





endmodule