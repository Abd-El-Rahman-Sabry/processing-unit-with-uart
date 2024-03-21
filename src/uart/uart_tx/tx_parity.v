`include "parameters.v"

module tx_partiy_calc(
    input wire [`WIDTH - 1 : 0] i_data,
    input wire i_type,
    output wire o_parity 
);



    wire x_p; 

    assign x_p = ^i_data; // If it's 1 there is an odd number of ones 

    assign o_parity = (i_type)? ~x_p: x_p;



endmodule