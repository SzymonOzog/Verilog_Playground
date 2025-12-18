module adder1(
    input wire a,
    input wire b,
    input wire carry_in,
    output wire y,
    output wire carry
    );
    assign y = a ^ b ^ carry_in;
    assign carry = (a & b) | (a & carry_in) | (b & carry_in);
endmodule


module adder8(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire carry_in,
        output wire[7:0] y,
        output wire carry_out
        );
    wire [7:0] bin;

    assign bin[0] = b[0]^carry_in;
    assign bin[1] = b[1]^carry_in;
    assign bin[2] = b[2]^carry_in;
    assign bin[3] = b[3]^carry_in;
    assign bin[4] = b[4]^carry_in;
    assign bin[5] = b[5]^carry_in;
    assign bin[6] = b[6]^carry_in;
    assign bin[7] = b[7]^carry_in;

    wire [6:0] carry;
    adder1 a0(a[0], bin[0], carry_in, y[0], carry[0]);
    adder1 a1(a[1], bin[1], carry[0], y[1], carry[1]);
    adder1 a2(a[2], bin[2], carry[1], y[2], carry[2]);
    adder1 a3(a[3], bin[3], carry[2], y[3], carry[3]);
    adder1 a4(a[4], bin[4], carry[3], y[4], carry[4]);
    adder1 a5(a[5], bin[5], carry[4], y[5], carry[5]);
    adder1 a6(a[6], bin[6], carry[5], y[6], carry[6]);
    adder1 a7(a[7], bin[7], carry[6], y[7], carry_out);

endmodule
