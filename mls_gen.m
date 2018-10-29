clc
clear variables;
cla 

init = [1 1 0 0 1]  % seed  
% primitive polynomials always have 1 for 0th order term
t = [5 2]  % x^5 + x^2 +1
len_pn_seq = 50
pn_seq = LFSR_PN(init,t,len_pn_seq);

mls = pn_seq*2-1;

correlation = xcorr(mls)/50;

stem(correlation)

% stem(mls)
% ylim([0 1.2])
% mean = mean(mls);
% s1 = std(mls);
% corralation = (mls-mean/s1).*(mls-mean/s1);

function pn_seq = LFSR_PN(shift_reg, taps, pn_seq_len)

pn_seq = NaN(pn_seq_len, 1);

for ii = 1 : pn_seq_len
    % output last element of shift register
    pn_seq(ii) = shift_reg(end);
    % new input
    reg_taps = shift_reg(taps);
    back = mod(sum(reg_taps), 2);
    % update register
    shift_reg = circshift(shift_reg, 1);
    shift_reg(1) = back;
    % update register
    shift_reg = shift_reg(1:end-1);  % pop
    shift_reg = horzcat(back, shift_reg);  % push

end

end