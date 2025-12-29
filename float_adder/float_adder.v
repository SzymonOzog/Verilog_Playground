module float_adder_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire clock,
        output wire[7:0] y
        );

        reg[3:0] a_e = a[6:3];
        reg[3:0] b_e = b[6:3];
        reg[3:0] y_e;


        reg[3:0] a_m = {1'b1, a[2:0]};
        reg[3:0] b_m = {1'b1, b[2:0]};
        reg[2:0] y_m;

        reg[3:0] diff;

        reg[2:0] shift_amt;
        reg sub_sign_change;

        reg[4:0] m_sum_tmp;
        reg[4:0] m_sum;
        reg[3:0] e_sum;

        reg add_carry;

        initial 
            begin
                diff = a_e - b_e;
                if (diff[3]) begin
                    shift_amt = ~(diff[2:0]) + 1'b1;
                    a_m = a_m >> shift_amt;
                    a_e += shift_amt;
                end else begin
                    shift_amt = diff[2:0];
                    b_m = b_m >> shift_amt;
                    b_e += shift_amt;
                end

                m_sum_tmp = a[7] ? b_m - a_m : 
                            b[7] ? a_m - b_m :
                                   a_m + b_m;

                m_sum = m_sum_tmp[4] ? ~(m_sum_tmp) + 1'b1 : m_sum_tmp;
                while (m_sum[3] != 1'b1)
                    begin
                        add_carry = m_sum[4] & !(a[7] & b[7]);
                        m_sum = add_carry ? m_sum >> 1 : m_sum << 1;
                        e_sum = add_carry ? e_sum + 1'b1 : e_sum - 1'b1;
                    end

            end

        assign y[7] = (a[7] & b[7]) || m_sum_tmp[3];
        assign y[6:3] = e_sum;
        assign y[2:0] = m_sum[2:0];
endmodule
