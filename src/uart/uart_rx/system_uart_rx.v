`include "rx_bit_cnt.v"
`include "rx_ctr.v"
`include "rx_deserializer.v"
`include "rx_sampler.v"
`include "rx_stop_chk.v"
`include "rx_start_chk.v"
`include "rx_parity_chk.v"



module system_uart_rx(
    input wire i_clk , i_rst , i_rx, 
    input wire i_par_type , i_en_par,
    input wire [4:0] i_prescale,

    output wire o_data_valid,
    output wire [`WIDTH - 1 : 0] o_data
);

    // Error check enable nets 
    wire en_par_chk , en_stp_chk , en_str_chk;

    // Unit enable nets 

    wire en_cnt , en_deser , en_sample;

    rx_ctrl u0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rx(i_rx),
        .i_par_type(i_par_type),
        .i_en_par(i_en_par),
        .i_bit_cnt(bit_cnt),
        .i_edge_cnt(edge_cnt),
        
        // Errors
        .i_par_err(par_err),
        .i_stp_err(stp_err),
        .i_str_err(str_err),
        
        // Enable 
        .o_en_sample(en_sample),
        .o_en_deser(en_deser),
        .o_en_cnt(en_cnt),


        // Enable error check 
        .o_en_par_chk(en_par_chk),
        .o_en_str_chk(en_str_chk),
        .o_en_stp_chk(en_stp_chk),


        .o_data_valid(o_data_valid)
    );

    wire [3:0] bit_cnt;
    wire [2:0] edge_cnt;

    rx_edge_bit_cnt u1(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en_cnt(en_cnt),
        .o_bit_cnt(bit_cnt),
        .o_edge_cnt(edge_cnt)
    );

    
    wire sampled_bit;

    rx_data_sample u2(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rx(i_rx),
        .i_en_samp(en_sample),
        .i_prescale(i_prescale),
        .i_edge_cnt(edge_cnt),
        .o_sampled_bit(sampled_bit)
    );

    wire par_err , stp_err , str_err;

    rx_par_chk u3(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en_chk(en_par_chk),
        .i_data(o_data),
        .i_par_type(i_par_type),
        .i_sampled_bit(sampled_bit),

        .o_par_err(par_err)
    );

    rx_str_chk u4(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en_chk(en_str_chk),
        .i_sampled_bit(sampled_bit),
        .o_str_err(str_err)
    );

    rx_stp_chk u5(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en_chk(en_stp_chk),
        .i_sampled_bit(sampled_bit),
        .o_stp_err(stp_err)
    );

    
    rx_deser u6(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en_deser(en_deser),
        .i_edge_cnt(edge_cnt),
        .i_sampled_bit(sampled_bit),

        .o_data(o_data)
    );

endmodule 