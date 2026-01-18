OUT := alu.out
SRC := $(wildcard *.v)

run:
	iverilog -g2012 -o $(OUT) ../float_adder/float_adder.v ../float_multiplier/float_multiplier.v -Wall $(SRC)
	vvp $(OUT) 

clean:
	rm -rf $(OUT) dump.vcd
