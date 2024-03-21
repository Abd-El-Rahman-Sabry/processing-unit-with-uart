
# Entity: system_top 
- **File**: system_top.v

## Diagram
![Diagram](system_top.svg "Diagram")
## Ports

| Port name  | Direction | Type | Description |
| ---------- | --------- | ---- | ----------- |
| i_ref_clk  | input     | wire |             |
| i_uart_clk |           |      |             |
| i_rst      |           |      |             |
| i_rx       |           |      |             |
| o_tx       | output    | wire |             |

## Signals

| Name            | Type                  | Description |
| --------------- | --------------------- | ----------- |
| ref_rst         | wire                  |             |
| uart_rst        | wire                  |             |
| async_rx_data   | wire [`WIDTH - 1 : 0] |             |
| sync_rx_data    | wire [`WIDTH - 1 : 0] |             |
| async_rx_signal | wire                  |             |
| sync_rx_signal  | wire                  |             |
| async_tx_data   | wire [`WIDTH - 1: 0]  |             |
| sync_tx_data    | wire [`WIDTH - 1: 0]  |             |
| async_tx_signal | wire                  |             |
| sync_tx_signal  | wire                  |             |
| uart_config     | wire [`WIDTH - 1 : 0] |             |
| clk_div_config  | wire [`WIDTH - 1 : 0] |             |
| rf_en_r         | wire                  |             |
| rf_en_w         | wire                  |             |
| rf_ld_data      | wire                  |             |
| rf_data_source  | wire                  |             |
| rf_add_source   | wire [1:0]            |             |
| rf_ld_add       | wire                  |             |
| reg_file_valid  | wire                  |             |
| alu_en          | wire                  |             |
| alu_ld_func_en  | wire                  |             |
| alu_clk_en      | wire                  |             |
| alu_valid       | wire                  |             |
| out_source      | wire                  |             |
| tx_clk          | wire                  |             |
| tx_busy         | wire                  |             |

## Instantiations

- u0: system_rst_sync
- u1: system_rst_sync
- u2: system_data_sync
- u3: system_data_sync
- u4: system_datapath
- u5: system_ctrl
- u6: system_clk_div
- u7: system_uart
