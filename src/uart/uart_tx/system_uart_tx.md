
# Entity: system_uart_tx 
- **File**: system_uart_tx.v

## Diagram
![Diagram](system_uart_tx.svg "Diagram")
## Ports

| Port name    | Direction | Type                  | Description |
| ------------ | --------- | --------------------- | ----------- |
| i_clk        | input     | wire                  |             |
| i_rst        |           |                       |             |
| i_data_valid |           |                       |             |
| i_data       | input     | wire [`WIDTH - 1 : 0] |             |
| i_par_type   | input     | wire                  |             |
| i_en_par     |           |                       |             |
| o_tx         | output    | wire                  |             |
| o_busy       |           |                       |             |

## Signals

| Name     | Type       | Description |
| -------- | ---------- | ----------- |
| ser_bit  | wire       |             |
| ser_en   | wire       |             |
| ser_done | wire       |             |
| par_bit  | wire       |             |
| mux_sel  | wire [1:0] |             |

## Instantiations

- u0: serializer
- u1: tx_ctrl
- u2: tx_partiy_calc
- u3: tx_mux
