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
        #1 a = 1;
        #1 b = 0;
        #2 b = 1;
        #3 a = 0;
        #4 $finish;
    end
endmodule

