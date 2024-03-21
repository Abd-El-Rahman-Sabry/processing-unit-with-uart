`ifndef __PARAMS__
`define __PARAMS__

// General Parameters
    
    // ALU Related Parametets 
		`define WIDTH 8 
		`define ALU_FUN_WIDTH 4


    // ALU operation 

		`define ADD         4'b0000
		`define SUB         4'b0001
		`define MUL         4'b0010 
		`define DIV         4'b0011 
		`define AND         4'b0100
		`define OR          4'b0101
		`define NAND        4'b0110
		`define NOR         4'b0111
		`define XOR         4'b1000
		`define XNOR        4'b1001 
		`define EQ          4'b1010 
		`define GT          4'b1011 
		`define SHR         4'b1100 
		`define SHL         4'b1101 



    // Register file 

		`define REG_FILE_SIZE           16
		`define REG_FILE_ADD_SIZE       $clog2(`REG_FILE_SIZE)
    

	
	
	// Datapath
	
		// Data Source at the input of register file 
		`define RF_SOURCE_RX_DATA 		0
		`define RF_SOURCE_ALU_OUT		1
		
	`define RF_ADD_OP_0				2'b00
	`define RF_ADD_OP_1				2'b01
	`define RF_ADD_RX_DATA			2'b10
	
		// Output source 
		`define OUT_SOURCE_ALU 			0
		`define OUT_SOURCE_RF			1
		
	// Commands 
	
	`define RF_W_CMD				'hAA 
	`define RF_R_CMD 				'hBB
	`define ALU_OP_CMD				'hCC
	`define ALU_F_CMD				'hDD 
	`define ALU_W_CMD				'hFF

`endif 