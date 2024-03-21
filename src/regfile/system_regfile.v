
`include "parameters.v"

module system_regfile(
    input wire i_clk , i_rst,
    
    input [`WIDTH - 1 : 0] i_data,
    input [`REG_FILE_ADD_SIZE - 1 : 0] i_add,
    
    input i_en_w , i_en_r, 


    output reg [`WIDTH - 1 : 0] o_data,
    output o_valid,

    output [`WIDTH - 1 : 0] o_reg_0 , o_reg_1 , o_reg_2 , o_reg_3 
);

    reg [`WIDTH - 1 : 0] reg_file_mem [ 0 : `REG_FILE_SIZE - 1];

    always @(posedge i_clk or negedge i_rst) begin
        if(~i_rst)
            begin
                for(integer  i = 0; i < `REG_FILE_SIZE ; i+=1)
                    begin
						if (i == 2)
							reg_file_mem[i] <= 'b0010_0001;
						else if (i == 3)
							reg_file_mem[i] <= 'b0000_1000;
						else 
							reg_file_mem[i] <= {`WIDTH{1'b0}};
                    end 
				o_data <= {`WIDTH{1'b0}};
            end 
        else 
            begin
                if (i_en_w)
                    reg_file_mem[i_add] <= i_data;
                
                if (i_en_r)
                    o_data <= reg_file_mem[i_add];

            end 
        
    end
    
    assign o_valid = i_en_r; 


    assign o_reg_0 = reg_file_mem[0];
    assign o_reg_1 = reg_file_mem[1];
    assign o_reg_2 = reg_file_mem[2];
    assign o_reg_3 = reg_file_mem[3];

endmodule 