`include "en_sync.v"
`include "parameters.v"

module system_data_sync #(
    parameter WIDTH = `WIDTH
)(
    input wire i_clk , i_rst ,
    input wire [WIDTH - 1 : 0] i_async_data, 
    input wire i_async_en, 

    output reg [WIDTH - 1 : 0] o_sync_data,
    output reg o_sync_en 
);
    
    // The next multi-line comment will be recognized by the 

    /*
        cdc-prop{
            cdc-ff-name : en_sync,
            cdc-ff-size : 2
        }
    */

    wire sync_en; 

    en_sync u0(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_async(i_async_en),
        .o_sync(sync_en)
    );

    // Pulse Generation 

    reg en_reg; 

    wire pulse; 

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    en_reg <= 1'b0; 
                end
            else 
                begin
                    en_reg <= sync_en;
                end 
        end 

    assign pulse = sync_en & (~en_reg);

    // Enable signal register 
    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_sync_en <= 1'b0;
                end 
            else 
                begin 
                    o_sync_en <= pulse;
                end  
        end 

    // Data register 

    reg [WIDTH - 1 : 0]  mux_out;

    always @(posedge i_clk or negedge i_rst)
        begin
            if(~i_rst)
                begin
                    o_sync_data <= {WIDTH{1'b0}};
                end
            else 
                begin
                    o_sync_data <= mux_out;
                end 
        end 

    always @(*)
        begin
            mux_out <= (pulse)? i_async_data : o_sync_data;
        end 

endmodule 


