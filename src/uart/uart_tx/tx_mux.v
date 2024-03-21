

module tx_mux(
    input wire i_stop_bit , i_start_bit , i_ser_bit , i_par_bit,
    input wire [1:0] i_sel,
    output reg o_ser_out  
);

    always @(*)
        begin
            case(i_sel)
                2'b00 : o_ser_out <= i_start_bit;
                2'b01 : o_ser_out <= i_ser_bit;
                2'b10 : o_ser_out <= i_par_bit;
                2'b11 : o_ser_out <= i_stop_bit;
            endcase 
        end 



endmodule 