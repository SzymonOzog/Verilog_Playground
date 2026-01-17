module float_adder_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire clock,
        input wire reset,
        output wire[7:0] y,
        output wire is_output_valid
        );

        wire[3:0] a_e = a[6:3];
        wire[3:0] b_e = b[6:3];

        reg[3:0] a_e_aligned;
        reg[3:0] b_e_aligned;

        wire[3:0] a_m = {1'b1, a[2:0]};
        wire[3:0] b_m = {1'b1, b[2:0]};
        reg[3:0] a_m_aligned;
        reg[3:0] b_m_aligned;

        reg[4:0] diff;

        reg[3:0] shift_amt;
        reg sub_sign_change;

        reg[4:0] m_sum_tmp;
        reg[4:0] m_sum;
        reg[4:0] m_sum_next;

        reg[3:0] e_sum;
        reg[3:0] e_sum_next;

        reg[1:0] curr_state;
        reg[1:0] next_state;
        reg next_valid;
        reg valid;

        wire sub_borrow;
        wire add_carry;

        parameter EXP = 2'd1;
        parameter NORM = 2'd2;
        assign sub_borrow = (m_sum_tmp[4] & (a[7] ^ b[7]));
        assign add_carry = m_sum[4] & !(a[7] ^ b[7]);

        always @ (posedge clock or posedge reset)
        begin
            if (reset)
            begin
                curr_state <= EXP;
                m_sum <= 4'd0;
                e_sum <= 3'd0;
                valid <= 1'b0;
                next_valid <= 1'b0;
            end
            else
            begin
                curr_state <= next_state;
                m_sum <= m_sum_next;
                e_sum <= e_sum_next;
                valid <= next_valid;
            end
        end

        always @ (*)
        begin
            case(curr_state)
                EXP:
                begin
                    diff = a_e - b_e;
                    if (diff[4]) begin
                        shift_amt = ~(diff[3:0]) + 1'b1;
                        a_m_aligned = a_m >> shift_amt;
                        a_e_aligned = a_e + shift_amt;
                        b_m_aligned = b_m;
                        b_e_aligned = b_e;
                        e_sum_next = b_e;
                    end 
                    else
                    begin
                        shift_amt = diff[3:0];
                        a_m_aligned = a_m;
                        a_e_aligned = a_e;
                        b_m_aligned = b_m >> shift_amt;
                        b_e_aligned = b_e + shift_amt;
                        e_sum_next = a_e;
                    end
                    m_sum_tmp = !(a[7] ^ b[7]) ? a_m_aligned + b_m_aligned :
                                a[7]           ? b_m_aligned - a_m_aligned : 
                                                 a_m_aligned - b_m_aligned ;
                                       
                    m_sum_next = sub_borrow ? ~(m_sum_tmp) + 1'b1 : m_sum_tmp;
                    next_state = NORM;
                end

                NORM:
                begin
                    //TODO is there a smarter way to do this
                    if (m_sum == 4'd0)
                    begin
                        next_valid = 1'b1;
                        e_sum_next = 4'd0;
                    end
                    else
                    begin
                        next_valid = m_sum[3];
                    end
                    if (!next_valid)
                    begin
                        m_sum_next = add_carry ? m_sum >> 1 : m_sum << 1;
                        e_sum_next = add_carry ? e_sum + 1'b1 : e_sum - 1'b1;
                    end
                end
            endcase
        end

        assign y[7] = (a[7] & b[7]) || sub_borrow;
        assign y[6:3] = e_sum;
        assign y[2:0] = m_sum[2:0];
        assign is_output_valid = valid;
endmodule

module float_adder_bf16(
        input wire[15:0] a,
        input wire[15:0] b,
        input wire clock,
        input wire reset,
        output wire[15:0] y,
        output wire is_output_valid
        );

        wire[7:0] a_e = a[14:7];
        wire[7:0] b_e = b[14:7];

        reg[7:0] a_e_aligned;
        reg[7:0] b_e_aligned;

        wire[7:0] a_m = (a_e == 8'b0) ? {1'b0, a[6:0]} : {1'b1, a[6:0]};
        wire[7:0] b_m = (b_e == 8'b0) ? {1'b0, b[6:0]} : {1'b1, b[6:0]};

        reg[7:0] a_m_aligned;
        reg[7:0] b_m_aligned;

        reg[7:0] y_e;
        reg[7:0] y_e_next;

        reg[6:0] y_m;
        reg[6:0] y_m_next;

        reg[8:0] diff;

        reg[7:0] shift_amt;
        reg sub_sign_change;

        reg[8:0] m_sum_tmp;
        reg[8:0] m_sum;
        reg[8:0] m_sum_next;

        reg[7:0] e_sum;
        reg[7:0] e_sum_next;

        reg[1:0] curr_state;
        reg[1:0] next_state;
        reg next_valid;
        reg valid;

        wire sub_borrow;
        wire add_carry;

        reg round_up;

        parameter EXP = 2'd1;
        parameter NORM = 2'd2;
        assign sub_borrow = (m_sum_tmp[8] & (a[15] ^ b[15]));
        assign add_carry = m_sum[8] & !(a[15] ^ b[15]);

        always @ (posedge clock or posedge reset)
        begin
            if (reset)
            begin
                curr_state <= EXP;
                m_sum <= 8'd0;
                e_sum <= 7'd0;
                valid <= 1'b0;
                next_valid <= 1'b0;
            end
            else
            begin
                curr_state <= next_state;
                m_sum <= m_sum_next;
                e_sum <= e_sum_next;
                valid <= next_valid;
            end
        end

        always @ (*)
        begin
            case(curr_state)
                EXP:
                begin
                    diff = a_e - b_e;
                    if (diff[8]) begin
                        shift_amt = ~(diff[7:0]) + 1'b1;
                        a_m_aligned = a_m >> shift_amt;
                        a_e_aligned = a_e + shift_amt;
                        b_m_aligned = b_m;
                        b_e_aligned = b_e;
                        e_sum_next = b_e;
                    end 
                    else
                    begin
                        shift_amt = diff[7:0];
                        a_m_aligned = a_m;
                        a_e_aligned = a_e;
                        b_m_aligned = b_m >> shift_amt;
                        b_e_aligned = b_e + shift_amt;
                        e_sum_next = a_e;
                    end
                    m_sum_tmp = !(a[15] ^ b[15]) ? a_m_aligned + b_m_aligned :
                                a[15]           ? b_m_aligned - a_m_aligned : 
                                                 a_m_aligned - b_m_aligned ;
                                       
                    m_sum_next = sub_borrow ? ~(m_sum_tmp) + 1'b1 : m_sum_tmp;
                    next_state = NORM;
                end

                NORM:
                begin
                    //TODO is there a smarter way to do this
                    if (m_sum == 8'd0)
                    begin
                        next_valid = 1'b1;
                        e_sum_next = 8'd0;
                    end
                    else
                    begin
                        next_valid = m_sum[7] && !m_sum[8];
                    end
                    if (!next_valid)
                    begin
                        if (add_carry)
                        begin
                            round_up = m_sum[0] && m_sum[1];
                            m_sum_next = m_sum >> 1;
                            e_sum_next = e_sum + 1'b1;
                            m_sum_next = round_up ? m_sum_next + 1'b1 : m_sum_next;
                        end
                        else
                        begin
                            m_sum_next = m_sum << 1;
                            e_sum_next = e_sum - 1'b1;
                        end
                    end
                end
            endcase
        end

        assign y[15] = (a[15] & b[15]) || sub_borrow;
        assign y[14:7] = e_sum;
        assign y[6:0] = m_sum[6:0];
        assign is_output_valid = valid;
endmodule
