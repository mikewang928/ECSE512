[y, fs] = audioread(input_file);
%plot(y)
hold on
cla reset; % Do a complete and total reset of the axes.


F_s = fs
% FL1=300
% FH1=1000
% FL2=1500
% FH2=2200
% FL3=2700
% FH3=3400
% FL4=4100
% FH4=4800
% FL5=5500
% FH5=6200
% Gain1 = 10
% Gain2 = 10
% Gain3 = 10
% Gain4 = 10
% Gain5 = 10

%K_L = 1/L1/L2

y_f = DRRS_5B_filtered(FL1,FL2,FL3,FL4,FL5,FH1,FH2,FH3,FH4,FH5,F_s, Gain1,Gain2,Gain3,Gain4,Gain5,y)

plot(y_f,'color','g')
hold on

plot(y,'color','b')
L(1) = plot(nan, nan, 'b-');
L(2) = plot(nan, nan, 'g-');
legend(L, {'Input Data', 'Filtered Data'})

title('Input and Output over time')

sound(y_f,fs)
%[hT, wT] = freqz(cell2mat(num), cell2mat(dem));
%plot(abs(hT))
function [y_f_5B] = DRRS_5B_filtered(FL1,FL2,FL3,FL4,FL5,FH1,FH2,FH3,FH4,FH5,F_s, Gain1,Gain2,Gain3,Gain4,Gain5,y)
    y_f_4B_1 = DRRS_4B_filtered(FL1,FL2,FL3,FL4,FH1,FH2,FH3,FH4,F_s, Gain1,Gain2,Gain3,Gain4,y);
    y_f_1B_1 = DRRS_1B_filtered(FL5,FH5,F_s,Gain5,y);
    y_f_5B =  (y_f_4B_1 + y_f_1B_1)/(sqrt(2));
end 

function [y_f_4B] = DRRS_4B_filtered(FL1,FL2,FL3,FL4,FH1,FH2,FH3,FH4,F_s, Gain1,Gain2,Gain3,Gain4,y)
    y_f_2B_1 = DRRS_2B_filtered(FL1,FL2,FH1,FH2,F_s, Gain1,Gain2,y);
    y_f_2B_2 = DRRS_2B_filtered(FL3,FL4,FH3,FH4,F_s, Gain3,Gain4,y);
    y_f_4B =  (y_f_2B_1 + y_f_2B_2)/(sqrt(2));
end 

function [y_f] = DRRS_2B_filtered(FL1,FL2,FH1,FH2,F_s, Gain1,Gain2,y)
    y_f_1 = DRRS_1B_filtered(FL1,FH1,F_s,Gain1,y);
    y_f_2 = DRRS_1B_filtered(FL2,FH2,F_s,Gain2,y);
    y_f = (y_f_1 + y_f_2)/(sqrt(2));
end 
function [y_f] = DRRS_1B_filtered(FL1,FH1,F_s,Gain,y)
    [fl,fb,fh] = DRRS_1B(FL1,FH1,F_s, Gain);
    [numl, deml] = tfdata(fl);
    [numb, demb] = tfdata(fb);
    [numh, demh] = tfdata(fh);
    y_1 = filter(cell2mat(numl), cell2mat(deml), y);
    y_2 = filter(cell2mat(numb), cell2mat(demb), y);
    y_3 = filter(cell2mat(numh), cell2mat(demh), y);
    y_f = (y_1 + y_2 + y_3)/(sqrt(3));
end 


function [fl,fb,fh] = DRRS_1B(FL1, FH1, F_s, Gain)
    L11 = FindL1(FL1,F_s);
    L12 = findL2(L11);
    H11 = FindL1(FH1,F_s);
    H12 = findL2(H11);
    K_L_1 = 1/(L11*L12);
    K_H_1 = 1/(H11*H12);
    ts = 1/F_s;
    z = tf('z',ts);

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