
# Entity: system_uart 
- **File**: system_uart.v

## Diagram
![Diagram](system_uart.svg "Diagram")
## Ports

| Port name   | Direction | Type                  | Description |
| ----------- | --------- | --------------------- | ----------- |
| i_clk       | input     | wire                  |             |
| i_tx_clk    |           |                       |             |
| i_rst       |           |                       |             |
| i_rx        |           |                       |             |
| i_sync_sig  | input     | wire                  |             |
| i_sync_data | input     | wire [`WIDTH - 1 : 0] |             |
| i_config    |           |                       |             |
| o_tx        | output    | wire                  |             |
| o_tx_busy   |           |                       |             |
| o_sync_data | output    | wire [`WIDTH - 1 : 0] |             |
| o_sync_sig  | output    | wire                  |             |

## Instantiations

- u0: system_uart_tx
- u1: system_uart_rx
