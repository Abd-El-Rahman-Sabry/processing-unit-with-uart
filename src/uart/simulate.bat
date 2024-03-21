
@echo off 


	title Sabry_Simulate 
	echo ....Reading the file %1
	echo ....Compiling files 
	iverilog -I .\uart_rx -I .\uart_tx -I .\clk_div -o immd.vvp %1 
	vvp immd.vvp > "verification_report.txt"
    del immd.vvp  
    echo done 
  