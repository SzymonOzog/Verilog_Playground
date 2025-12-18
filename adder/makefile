BUILD ?= build

SRC := $(wildcard *.v)

run:
	mkdir -p build
	iverilog -g2012 -Wall $(SRC)
	vvp a.out

clean:
	rm -rf build
