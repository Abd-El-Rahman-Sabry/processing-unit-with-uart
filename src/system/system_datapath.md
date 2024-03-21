
# Entity: system_datapath 
- **File**: system_datapath.v

## Diagram
![Diagram](system_datapath.svg "Diagram")
## Ports

| Port name        | Direction | Type                  | Description |
| ---------------- | --------- | --------------------- | ----------- |
| i_clk            | input     | wire                  |             |
| i_rst            |           |                       |             |
| i_alu_en         | input     | wire                  |             |
| i_ld_alu_func    |           |                       |             |
| i_alu_clk_en     |           |                       |             |
| i_rx_data_valid  | input     | wire                  |             |
| i_en_r           | input     | wire                  |             |
| i_en_w           |           |                       |             |
| i_ld_rf_data     | input     | wire                  |             |
| i_rf_data_source |           |                       |             |
| i_ld_rf_add      | input     | wire                  |             |
| i_rf_add_source  | input     | wire [1:0]            |             |
| i_output_source  | input     | wire                  |             |
| i_rx_data        | input     | wire [`WIDTH - 1 : 0] |             |
| o_reg_file_valid | output    | wire                  |             |
| o_alu_valid      |           |                       |             |
| o_uart_config    | output    | wire [`WIDTH -1 : 0]  |             |
| o_clk_div_config |           |                       |             |
| o_tx_data        | output    | [`WIDTH - 1 : 0]      |             |

## Signals

| Name          | Type                             | Description |
| ------------- | -------------------------------- | ----------- |
| alu_gated_clk | wire                             |             |
| alu_op_0      | wire [`WIDTH - 1 : 0]            |             |
| alu_op_1      | wire [`WIDTH - 1 : 0]            |             |
| alu_out       | wire [`WIDTH - 1 : 0]            |             |
| func_reg      | reg [`ALU_FUN_WIDTH - 1 : 0]     |             |
| data_in_reg   | reg [`WIDTH - 1: 0]              |             |
| add_in_reg    | reg [`REG_FILE_ADD_SIZE - 1 : 0] |             |
| reg_file_out  | wire [`WIDTH - 1 : 0]            |             |

## Processes
- unnamed: ( @(posedge i_clk or negedge i_rst) )
  - **Type:** always
- unnamed: ( @(posedge i_clk or negedge i_rst) )
  - **Type:** always
- unnamed: ( @(posedge i_clk or negedge i_rst) )
  - **Type:** always
- unnamed: ( @(posedge i_clk or negedge i_rst) )
  - **Type:** always

## Instantiations

- u2: system_clk_gate
- u0: system_alu
- u1: system_regfile
