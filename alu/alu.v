module alu(
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

        reg[7:0] out;
        reg[7:0] next_out;

        reg valid; 
        reg next_valid;

        assign y = out;
        assign is_output_valid = valid;

        float_adder_e4m3 adder(a, b, clock, reset, add_y, add_valid);
        float_multiplier_e4m3 multiplier(a, b, clock, reset, mul_y, mul_valid);

        always @ (posedge clock or posedge reset)
        begin
            if (reset)
            begin
                out <= 8'd0;
                next_out <= 8'd0;
                valid <= 1'b0;
                next_valid <= 1'b0;
            end
            else
                out <= next_out;
                valid <= next_valid;
            begin
            end
        end

        always @ (*)
        begin
            case(alu_ctrl)
            4'b0001:
            begin
                next_valid = add_valid;
                next_out = add_y;
            end
            4'b0010:
            begin
                next_valid = mul_valid;
                next_out = mul_y;
            end
            default:
            begin
                next_valid = 1'b0;
                next_out = 8'd0;
            end
            endcase
        end
endmodule
