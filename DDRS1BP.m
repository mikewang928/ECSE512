
% testing 
F_s = 44100
L1 = 75
L2 = 51
H1 = 9
H2 = 7
K_L = 1/L1/L2
K_H = 1/H1/H2
testBP = BandPass_Z(L1,L2,H1,H2,K_L,K_H,F_s)
[num, dem] = tfdata(testBP)
[hT, wT] = freqz(cell2mat(num), cell2mat(dem));

plot((wT*F_s)/(2*pi), 20*log10(abs(hT)))

% this is a test file for a single bandpass filter designed by using drrs
% technique 
function BandPass = BandPass_Z(L1,L2,H1,H2,K_L,K_H,F_s)
    ts = 1/F_s;
    z = tf('z',ts);
    BandPass = K_H*(z^(-1*((L1+L2)/2)+1))*DRRS_tf_Z(H1,H2,F_s)-K_L*z^(-1*((H1+H2)/2)+1)*DRRS_tf_Z(L1,L2,F_s);
end

function DRRS = DRRS_tf_Z(L1,L2,F_s)
    numerator1 = [1, zeros(1, L1-1), -1];
    numerator2 = [1, zeros(1, L2-1), -1];
    numeratorT = conv(numerator1, numerator2);
    denominator = [1, -1];
    ts = 1/F_s;
    % was DRRS = 1/L1/L2*tf(numeratorT,denominator,ts,'Variable','z^-1');
    DRRS = tf(numeratorT,denominator,ts,'Variable','z^-1');
end 