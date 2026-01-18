module alu_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire[3:0] alu_ctrl,
        input wire clock,
        input wire reset,
        output wire[7:0] y,
        output wire is_output_valid
        );

        wire[7:0] mul_y;
        wire mul_valid;
        
        wire[7:0] add_y;
        wire add_valid;

        float_adder_e4m3 adder(a, b, clock, reset, add_y, add_valid);
        float_multiplier_e4m3 multiplier(a, b, clock, reset, mul_y, mul_valid);

        assign y = (alu_ctrl == 4'b0001) ? add_y :
                   (alu_ctrl == 4'b0010) ? mul_y : 8'd0;

        assign is_output_valid =
                   (alu_ctrl == 4'b0001) ? add_valid :
                   (alu_ctrl == 4'b0010) ? mul_valid : 1'b0;

endmodule

module alu_bf16(
        input wire[15:0] a,
        input wire[15:0] b,
        input wire[3:0] alu_ctrl,
        input wire clock,
        input wire reset,
        output wire[15:0] y,
        output wire is_output_valid
        );

        wire[15:0] mul_y;
        wire mul_valid;
        
        wire[15:0] add_y;
        wire add_valid;

        float_adder_bf16 adder(a, b, clock, reset, add_y, add_valid);
        float_multiplier_bf16 multiplier(a, b, clock, reset, mul_y, mul_valid);

        assign y = (alu_ctrl == 4'b0001) ? add_y :
                   (alu_ctrl == 4'b0010) ? mul_y : 8'd0;

        assign is_output_valid =
                   (alu_ctrl == 4'b0001) ? add_valid :
                   (alu_ctrl == 4'b0010) ? mul_valid : 1'b0;

endmodule
