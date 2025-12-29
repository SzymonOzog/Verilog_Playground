module float_adder_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire clock,
        input wire reset,
        output wire[7:0] y
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

        parameter EXP = 2'd1;
        parameter NORM = 2'd2;

        reg add_carry;
        always @ (posedge clock or posedge reset)
        begin
            if (reset)
            begin
                curr_state <= EXP;
                m_sum <= 4'd0;
                e_sum <= 3'd0;
            end
            else
            begin
                curr_state <= next_state;
                m_sum <= m_sum_next;
                e_sum <= e_sum_next;
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
                    m_sum_tmp = a[7] ? b_m_aligned - a_m_aligned : 
                                b[7] ? a_m_aligned - b_m_aligned :
                                       a_m_aligned + b_m_aligned;
                    m_sum_next = m_sum_tmp[4] ? ~(m_sum_tmp) + 1'b1 : m_sum_tmp;
                    next_state = NORM;
                end

                NORM:
                begin
                    if (!m_sum[3])
                    begin
                        add_carry = m_sum[4] & !(a[7] & b[7]);
                        m_sum_next = add_carry ? m_sum >> 1 : m_sum << 1;
                        e_sum_next = add_carry ? e_sum + 1'b1 : e_sum - 1'b1;
                    end
                end
            endcase
        end

        assign y[7] = (a[7] & b[7]) || (m_sum_tmp[3] & (a[7] ^ b[7]));
        assign y[6:3] = e_sum;
        assign y[2:0] = m_sum[2:0];
endmodule
