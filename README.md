# Processing Unit with UART

![System](https://github.com/Abd-El-Rahman-Sabry/Processing-Unit-with-UART/assets/82292548/ccccb3af-a3f1-494d-bcd9-6d392975e323)


# UART Processing Unit

## Project Overview
This project demonstrates the integration of a UART (Universal Asynchronous Receiver-Transmitter) with a processing unit. The processing unit consists of a datapath controlled by commands sent serially through the UART interface. The design incorporates two clock domains: one for the UART module and another for the processing unit. The system is managed by a finite state machine (FSM) that ensures proper synchronization and operation.

---

## Features
- **Dual Clock Domain Design**: Separate clock domains for the UART and processing unit ensure reliable operation.
- **UART Communication**: Provides a serial interface for sending and receiving commands.
- **Datapath Processing Unit**: Executes operations based on the commands received via UART.
- **FSM Control**: A state machine controls all operations and transitions in the system.
- **Command-Based Control**: Dynamically controls the datapath behavior through UART inputs.
- **Scalable Design**: Easily extendable to include additional commands or operations.

---

## Block Diagram

```plaintext
+------------+        +------------+       +------------+
| UART TX/RX | -----> | FSM        | -----> | Datapath   |
| Interface  |        | Controller |       | Processing |
+------------+        +------------+       +------------+
```

---

## Components

### 1. UART Module
- **Transmit (TX)**: Sends data serially to external devices.
- **Receive (RX)**: Receives serial data and forwards it to the FSM.
- **Baud Rate Configuration**: Supports standard baud rates for communication.

### 2. FSM Controller
- Implements a state machine to manage the operation of the datapath and UART modules.
- Ensures proper synchronization between clock domains.

### 3. Datapath
- Performs arithmetic and logical operations.
- Controlled by signals from the FSM.
- Consists of registers, ALU (Arithmetic Logic Unit), and control logic.

---

## Workflow

1. **Initialization**:
   - Configure the UART module with the desired baud rate.
   - Reset the processing unit to its initial state.

2. **Command Transmission**:
   - Send commands serially via the UART interface.

3. **FSM Control**:
   - The FSM decodes the received commands and generates control signals.

4. **Datapath Execution**:
   - The datapath performs operations based on the FSM-generated control signals.

5. **Output**:
   - Results from the datapath are transmitted back via UART (optional).

---

## FSM State Machine
The FSM manages the control signals and transitions through various states to coordinate the operations of the system.

### State Definitions
| State        | Description                               |
|--------------|-------------------------------------------|
| `IDLE`       | Waits for a new command from UART.        |
| `LD_D_RX`    | Loads data received from UART.           |
| `LD_FUNC`    | Loads the ALU function to be executed.   |
| `LD_OP_0`    | Loads the first operand into the ALU.    |
| `LD_OP_1`    | Loads the second operand into the ALU.   |
| `LD_ALU_OUT` | Loads the ALU output for transmission.   |
| `SEND_ALU`   | Sends the ALU result via UART.           |
| `WRITE`      | Writes data to the register file.        |


---

## Getting Started

### Prerequisites
- HDL Tools: Verilog/VHDL Simulator (e.g., ModelSim, Vivado)

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/Abd-El-Rahman-Sabry/processing-unit-with-uart.git
   ```
2. Open the project in your HDL development environment.
3. Synthesize and implement the design.
4. Use a UART terminal to send commands and observe the datapath behavior.

---

## Future Enhancements
- Add support for more complex commands.
- Implement error detection mechanisms for UART communication.
- Extend the datapath to include advanced operations like multiplication and division.

---

## License
This project is licensed under the [MIT License](LICENSE).

---

## Contributors
- [Sabry](https://github.com/Abd-El-Rahman-Sabry) - Hardware Verification Engineer & IC Design Enthusiast.
