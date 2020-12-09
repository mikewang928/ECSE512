[y, fs] = audioread('test.wav');
%plot(y)
%sound(y,fs);
FL1 = 40;
FH1 = 1000;
FL2 = 3000;
FH2 = 6000;
FL3 = 6001;
FH3 = 9000;
FL4 = 9001;
FH4 = 12000;
FL5 = 12001;
FH5 = 40000;
testBP = DRRS_5B_BandPass(FL1,FH1,FL2,FH2,FL3,FH3,FL4,FH4,FL5,FH5,fs,1,1,0,0,0)
[num, dem] = tfdata(testBP)
y_f = filter(cell2mat(num), cell2mat(dem),y);
% plot(y_f)
while i < length(y_f)
    if y_f(i)>1
        y_f(i) = 0.99;
    elseif y_f(i)<-1
        y_f(i) = -0.99;
    end
    i = i + 1;
end 
sound(y_f,fs);

filename = 'afterFilter.wav';
audiowrite(filename,y_f,fs);

function DRRS_5_tf = DRRS_5B_BandPass(FL1,FH1,FL2,FH2,FL3,FH3,FL4,FH4,FL5,FH5,F_s,factor1,factor2,factor3,factor4,factor5)
    DRRS_5_tf = (DRRS_2B_BandPass(FL1,FH1,FL2,FH2,F_s,factor1,factor2)+DRRS_2B_BandPass(FL3,FH3,FL4,FH4,F_s,factor3,factor4)+DRRS_1B_BandPass(FL5,FH5,F_s,factor5));
end



% this will return a dual band pass filter tranfer fuction in z-domain 
function DRRS_tf= DRRS_2B_BandPass(FL1,FH1,FL2,FH2,F_s,factor1,factor2)
    L11 = FindL1(FL1,F_s);
    L12 = findL2(L11);
    H11 = FindL1(FH1,F_s);
    H12 = findL2(H11);
    L21 = FindL1(FL2,F_s);
    L22 = findL2(L21);
    H21 = FindL1(FH2,F_s);
    H22 = findL2(H21);
    K_L_1 = 1/(L11*L12);
    K_H_1 = 1/(H11*H12);
    K_L_2 = 1/(L21*L22);
    K_H_2 = 1/(H21*H22);
    ts = 1/F_s;
    z = tf('z',ts);
    DRRS_tf = factor1*(K_H_1*(z^(-1*((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s)-K_L_1*z^(-1*((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s))+factor2*(K_H_2*(z^(-1*((L21+L22)/2)+1))*DRRS_tf_Z(H21,H22,F_s)-K_L_2*z^(-1*((H21+H22)/2)+1)*DRRS_tf_Z(L21,L22,F_s));
end

% this is a test file for a single bandpass filter designed by using drrs
% technique 
function BandPass = DRRS_1B_BandPass(FL1,FH1,F_s,factor)
    L11 = FindL1(FL1,F_s);
    L12 = findL2(L11);
    H11 = FindL1(FH1,F_s);
    H12 = findL2(H11);
    K_L_1 = 1/(L11*L12);
    K_H_1 = 1/(H11*H12);
    ts = 1/F_s;
    z = tf('z',ts);
    BandPass = factor*(K_H_1*(z^(-1*((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s)-K_L_1*z^(-1*((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s));
end

function DRRS = DRRS_tf_Z(L1,L2,F_s)
    numerator1 = [1, zeros(1, L1-1), -1];
    numerator2 = [1, zeros(1, L2-1), -1];
    numeratorT = conv(numerator1, numerator2);
    denominator = [1, -1];
    denominatorT = conv(denominator,denominator);
    ts = 1/F_s;
    % was DRRS = 1/L1/L2*tf(numeratorT,denominatorT,ts,'Variable','z^-1');
    DRRS = tf(numeratorT,denominatorT,ts,'Variable','z^-1');
end 

% this function can find the desired L1 value
function L1 = FindL1(fc, F_s)
    closestDistTo0_5=inf;
    foundL1 = 0;
    upper = 1/(fc/F_s)+1;
    for i=1:2:upper
        j = findL2(i);
        DRRS_mag = abs(DRRS_W(i,j,fc,F_s));
        DistTo0_5 = abs(DRRS_mag - 0.5);
        if DistTo0_5 < closestDistTo0_5
            closestDistTo0_5 = DistTo0_5;
            foundL1 = i;
        end 
    end 
    L1 = foundL1;
end

function DRRS = DRRS_W(L1,L2,fc,F_s)
    temp = pi*fc/F_s;
    DRRS = (exp(-2*1i*temp*(L1+L2-2)))*(sin(temp*L1)*sin(temp*L2))/(sin(temp)*sin(temp)*L1*L2);
end 

function L2 = findL2(L1)
   temp = round(L1/sqrt(2));
   if mod(temp,2) == 0
       L2 = temp+1;
   else 
       L2=temp;
   end
end 