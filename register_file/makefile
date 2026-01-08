OUT := regfile.out
SRC := $(wildcard *.v)

run:
	iverilog -g2012 -o $(OUT) -Wall $(SRC)
	vvp $(OUT) 

clean:
	rm -rf $(OUT) dump.vcd
