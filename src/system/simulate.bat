
@echo off 


	title Sabry_Simulate 
	echo ....Reading the file %1
	echo ....Compiling files 
	iverilog -I .\..\uart -I .\..\uart\uart_tx -I .\..\uart\uart_rx -I .\..\clk_div -I .\..\sync  -I 	.\..\alu  -I.\..\regfile	-I 	.\..\clk_gate 	-I .\..		-o immd.vvp %1 
	vvp immd.vvp > "verification_report.txt"
    del immd.vvp  
    echo done 
  