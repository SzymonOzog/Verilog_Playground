module tb;
    reg a;
    reg b;
    wire y;

    and_gate uut(.a(a), .b(b), .y(y));


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        a = 0;
        b = 0;
        
        #1 assert(y === 1'b0) else $fatal(1, "wrong output for a0b0");

        a = 1;
        b = 0;

        #1 assert(y === 1'b0) else $fatal(1, "wrong output for a1b0");

        a = 1;
        b = 1;

        #1 assert(y === 1'b1) else $fatal(1, "wrong output for a1b1");

        a = 0;
        b = 1;

        #1 assert(y === 1'b0) else $fatal(1, "wrong output for a0b1");

        $display("All test passed");
        $finish;
    end
endmodule

