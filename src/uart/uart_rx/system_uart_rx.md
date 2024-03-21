
# Entity: system_uart_rx 
- **File**: system_uart_rx.v

## Diagram
![Diagram](system_uart_rx.svg "Diagram")
## Ports

| Port name    | Direction | Type                  | Description |
| ------------ | --------- | --------------------- | ----------- |
| i_clk        | input     | wire                  |             |
| i_rst        |           |                       |             |
| i_rx         |           |                       |             |
| i_par_type   | input     | wire                  |             |
| i_en_par     |           |                       |             |
| i_prescale   | input     | wire [4:0]            |             |
| o_data_valid | output    | wire                  |             |
| o_data       | output    | wire [`WIDTH - 1 : 0] |             |

## Signals

| Name        | Type       | Description |
| ----------- | ---------- | ----------- |
| en_par_chk  | wire       |             |
| en_stp_chk  | wire       |             |
| en_str_chk  | wire       |             |
| en_cnt      | wire       |             |
| en_deser    | wire       |             |
| en_sample   | wire       |             |
| bit_cnt     | wire [3:0] |             |
| edge_cnt    | wire [2:0] |             |
| sampled_bit | wire       |             |
| par_err     | wire       |             |
| stp_err     | wire       |             |
| str_err     | wire       |             |

## Instantiations

- u0: rx_ctrl
- u1: rx_edge_bit_cnt
- u2: rx_data_sample
- u3: rx_par_chk
- u4: rx_str_chk
- u5: rx_stp_chk
- u6: rx_deser
