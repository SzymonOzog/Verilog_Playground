OUT := gpu.out
SRC := $(filter-out %/tb.v,$(wildcard ../*/*.v)) tb.v

run:
	iverilog -g2012 -o $(OUT) -Wall $(SRC)
	vvp $(OUT) 

clean:
	rm -rf $(OUT) dump.vcd
