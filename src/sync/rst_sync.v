module system_rst_sync #(
    parameter WIDTH = 1
) (
    input wire i_clk , i_rst,
    input wire [WIDTH - 1 : 0] i_async,
    output reg [WIDTH - 1 : 0] o_sync
);
    
	reg [WIDTH - 1: 0] meta_0;
    
    always @(posedge i_clk or negedge i_rst) begin
        if(~i_rst)
            begin
                
				meta_0 <= {WIDTH{1'b0}};
            end 
        else 
            begin
                
				meta_0 <= i_async;
				o_sync <= meta_0;

            end 
    end

endmodule
