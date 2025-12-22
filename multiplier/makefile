OUT := multiplier.out
SRC := $(wildcard *.v)

run:
	iverilog -g2012 -o $(OUT) ../adder/adder.v -Wall $(SRC)
	vvp $(OUT) 

clean:
	rm -rf $(OUT) dump.vcd
