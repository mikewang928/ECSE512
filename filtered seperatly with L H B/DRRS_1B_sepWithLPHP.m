[y, fs] = audioread('handel.wav');
%plot(y)
hold on
% testing 
F_s = fs
FL1=300
FH1=1000
%FL2=3000
%FH2=4000
Gain1 = 10
%Gain2=1
%K_L = 1/L1/L2
[fl,fb,fh] = DRRS_1B(FL1,FH1,F_s, Gain1);
[numl, deml] = tfdata(fl);
[numb, demb] = tfdata(fb);
[numh, demh] = tfdata(fh);
%bl = cell2mat(numl);
%al = cell2mat(deml);  
%bb = cell2mat(numb);
%ab = cell2mat(demb);  
%bh = cell2mat(numh);
%ah = cell2mat(demh);  
%b_ = conv(bh,conv(bl,bb));
%a_ = conv(ah,conv(al,ab));

% fvtool(b_,a_)

%y_f = filter(bh, ah, filter(bb, ab, filter(bl, al, y)));
y_1 = filter(cell2mat(numl), cell2mat(deml), y);
y_2 = filter(cell2mat(numb), cell2mat(demb), y);
y_3 = filter(cell2mat(numh), cell2mat(demh), y);
y_f = (y_1 + y_2 + y_3)/(sqrt(3))

plot(y)
hold on
plot(y_f)
legend('Input Data','Filtered Data')
title('First Row')

sound(y_f,fs)
%[hT, wT] = freqz(cell2mat(num), cell2mat(dem));
%plot(abs(hT))




function [fl,fb,fh] = DRRS_1B(FL1, FH1, F_s, Gain)
    L11 = FindL1(FL1,F_s);
    L12 = findL2(L11);
    H11 = FindL1(FH1,F_s);
    H12 = findL2(H11);
    K_L_1 = 1/(L11*L12);
    K_H_1 = 1/(H11*H12);
    ts = 1/F_s;
    z = tf('z',ts);
    
    %+Gain*(K_H_1*(z^(-1*((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s)-K_L_1*z^(-1*((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s))
    %1*z^(-((L11+L12)/2)+1)*(z^(-((H11+H12)/2)+1)-K_H_1*DRRS_tf_Z(H11,H12,F_s))+Gain*(K_H_1*(z^(-1*((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s)-K_L_1*z^(-1*((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s))+1*K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s)1*K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s)
%     DRRS1B = 3.1626*z^(-((L11+L12)/2)+1)*(z^(-((H11+H12)/2)+1)-K_H_1*DRRS_tf_Z(H11,H12,F_s))+ ... 
%         Gain*(K_H_1*(z^(-((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s) - K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s))+ ...
%         0.3162*K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s);

    fl = 3.1626*z^(-((L11+L12)/2)+1)*(z^(-((H11+H12)/2)+1)-K_H_1*DRRS_tf_Z(H11,H12,F_s));
    fb = Gain*(K_H_1*(z^(-((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s) - K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s));
    fh = 0.3162*K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s);
end 

function DRRS = DRRS_tf_Z(L1,L2,F_s)
    numerator1 = [1, zeros(1, L1-1), -1];
    numerator2 = [1, zeros(1, L2-1), -1];
    numeratorT = conv(numerator1, numerator2);
    denominator1 = [1, -1, zeros(1, L1-1)];
    denominator2 = [1, -1, zeros(1, L2-1)];
    denominatorT = conv(denominator1,denominator2);
    ts = 1/F_s;
    % was DRRS = 1/L1/L2*tf(numeratorT,denominatorT,ts,'Variable','z^-1');
    DRRS = tf(numeratorT,denominatorT,ts,'Variable','z');
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