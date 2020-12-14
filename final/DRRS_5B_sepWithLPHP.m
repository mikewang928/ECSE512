
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  connected to the gui.m               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y, fs] = audioread(input_file);% the input file can be added by using the user input in the UI.
hold on
cla reset; % Do a complete and total reset of the axes.
F_s = fs

% the parameters FL1, FL2, FL3, FL4, FL5, FH1, FH2, FH3, FH4, FH5, F_s,
% Gain1, Gain2, Gain3, Gain4, Gain5 and y can be added by using the
% user input in the UI. 
y_f = DRRS_5B_filtered(FL1,FL2,FL3,FL4,FL5,FH1,FH2,FH3,FH4,FH5,F_s, Gain1,Gain2,Gain3,Gain4,Gain5,y)
plot(y_f,'color','g')
hold on





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     ploting procedure                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(y,'color','b')
L(1) = plot(nan, nan, 'b-'); % this is done so that the legend will consistently having the same color
L(2) = plot(nan, nan, 'g-');
legend(L, {'Input Data', 'Filtered Data'})
title('Input and Output over time')

sound(y_f,fs)
%%%% freqz is used to determine the frequency reponse of a tranfer function
%%%% with num and dem 
% [hT, wT] = freqz(cell2mat(num), cell2mat(dem));
% plot(abs(hT))






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   function defination                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y_f_5B] = DRRS_5B_filtered(FL1,FL2,FL3,FL4,FL5,FH1,FH2,FH3,FH4,FH5,F_s, Gain1,Gain2,Gain3,Gain4,Gain5,y)
    %=================================================
    % 5-Band DRRS network algorithm
    % 
    % Parameters
    % FL1 : scalar 
    %   The first Low cut-off frequency
    % FH1 : scalar
    %   The first Low cut-off frequency
    % FL2 : scalar 
    %   The second Low cut-off frequency
    % FH2 : scalar
    %   The second Low cut-off frequency
    % FL3 : scalar 
    %   The third Low cut-off frequency
    % FH3 : scalar
    %   The third Low cut-off frequency
    % FL4 : scalar 
    %   The fourth cut-off frequency
    % FH4 : scalar
    %   The fourth Low cut-off frequency
    % FL5 : scalar 
    %   The fifth cut-off frequency
    % FH5 : scalar
    %   The fifth Low cut-off frequency
    % F_s : scalar
    %   The smapling frequency of the input data
    %
    % Gain1 : scalar
    %   The first selected band gain
    % Gain2 : scalar
    %   The second selected band gain
    % Gain3 : scalar
    %   The third selected band gain
    % Gain4 : scalar
    %   The forth selected band gain
    % Gain5 : scalar
    %   The fifth selected band gain
    %
    % y : 1XN vector/matrix 
    %   The filtering data set
    %=================================================
    y_f_4B_1 = DRRS_4B_filtered(FL1,FL2,FL3,FL4,FH1,FH2,FH3,FH4,F_s, Gain1,Gain2,Gain3,Gain4,y); % filtered by 4-band
    y_f_1B_1 = DRRS_1B_filtered(FL5,FH5,F_s,Gain5,y); % filtered by 1-band 
    y_f_5B =  (y_f_4B_1 + y_f_1B_1)/(sqrt(2)); % desired output 
end 

function [y_f_4B] = DRRS_4B_filtered(FL1,FL2,FL3,FL4,FH1,FH2,FH3,FH4,F_s, Gain1,Gain2,Gain3,Gain4,y)
%=================================================
    % 4-Band DRRS network algorithm
    % 
    % Parameters
    % FL1 : scalar 
    %   The first Low cut-off frequency
    % FH1 : scalar
    %   The first Low cut-off frequency
    % FL2 : scalar 
    %   The second Low cut-off frequency
    % FH2 : scalar
    %   The second Low cut-off frequency
    % FL3 : scalar 
    %   The third Low cut-off frequency
    % FH3 : scalar
    %   The third Low cut-off frequency
    % FL4 : scalar 
    %   The fourth cut-off frequency
    % FH4 : scalar
    %   The fourth Low cut-off frequency
    % F_s : scalar
    %   The smapling frequency of the input data
    %
    % Gain1 : scalar
    %   The first selected band gain
    % Gain2 : scalar
    %   The second selected band gain
    % Gain3 : scalar
    %   The third selected band gain
    % Gain4 : scalar
    %   The forth selected band gain
    %
    % y : 1XN vector/matrix 
    %   The filtering data set
    %=================================================

    y_f_2B_1 = DRRS_2B_filtered(FL1,FL2,FH1,FH2,F_s, Gain1,Gain2,y); % filtered by 2-band
    y_f_2B_2 = DRRS_2B_filtered(FL3,FL4,FH3,FH4,F_s, Gain3,Gain4,y); % filtered by 2-band
    y_f_4B =  (y_f_2B_1 + y_f_2B_2)/(sqrt(2)); % desired output
end 

function [y_f] = DRRS_2B_filtered(FL1,FL2,FH1,FH2,F_s, Gain1,Gain2,y)
    %=================================================
    % 2-Band DRRS network algorithm
    % 
    % Parameters
    % FL1 : scalar 
    %   The first Low cut-off frequency
    % FH1 : scalar
    %   The first Low cut-off frequency
    % FL2 : scalar 
    %   The second Low cut-off frequency
    % FH2 : scalar
    %   The second Low cut-off frequency
    % F_s : scalar
    %   The smapling frequency of the input data
    %
    % Gain1 : scalar
    %   The first selected band gain
    % Gain2 : scalar
    %   The second selected band gain
    %
    % y : 1XN vector/matrix 
    %   The filtering data set
    %=================================================
    y_f_1 = DRRS_1B_filtered(FL1,FH1,F_s,Gain1,y); % filtered by 1-band 
    y_f_2 = DRRS_1B_filtered(FL2,FH2,F_s,Gain2,y); % filtered by 1-band 
    y_f = (y_f_1 + y_f_2)/(sqrt(2));  % desired output
end 
function [y_f] = DRRS_1B_filtered(FL1,FH1,F_s,Gain,y)
    %=================================================
    % 1-Band DRRS network algorithm
    % 
    % Parameters
    % FL1 : scalar 
    %   The first Low cut-off frequency
    % FH1 : scalar
    %   The first Low cut-off frequency
    % F_s : scalar
    %   The smapling frequency of the input data    
    %
    % Gain1 : scalar
    %   The first selected band gain
    %
    % y : 1XN vector/matrix 
    %   The filtering data set
    %=================================================
    [fl,fb,fh] = DRRS_1B(FL1,FH1,F_s, Gain); % filtered by 1-band 
    [numl, deml] = tfdata(fl); % extracting the numerator and denumator from Low-pass portion of the transfer function 
    [numb, demb] = tfdata(fb); % extracting the numerator and denumator from Band-pass portion of the transfer function
    [numh, demh] = tfdata(fh); % extracting the numerator and denumator from High-pass portion of the transfer function
    y_1 = filter(cell2mat(numl), cell2mat(deml), y); % creating a filter, and pasing the input data into it
    y_2 = filter(cell2mat(numb), cell2mat(demb), y); % creating a filter, and pasing the input data into it
    y_3 = filter(cell2mat(numh), cell2mat(demh), y); % creating a filter, and pasing the input data into it
    y_f = (y_1 + y_2 + y_3)/(sqrt(3)); % desired output
end 


function [fl,fb,fh] = DRRS_1B(FL1, FH1, F_s, Gain)
    %=================================================
    % 1-Band DRRS network transfer function
    % 
    % Parameters
    % FL1 : scalar 
    %   The first Low cut-off frequency
    % FH1 : scalar
    %   The first Low cut-off frequency
    % F_s : scalar
    %   The smapling frequency of the input data
    %
    % Gain1 : scalar
    %   The first selected band gain
    %
    % y : 1XN vector/matrix 
    %   The filtering data set
    %=================================================
    L11 = FindL1(FL1,F_s); % find desired L1 given cut-off frequency 
    L12 = findL2(L11);% find L2 given L1 
    H11 = FindL1(FH1,F_s); % find desired H1 given cut-off frequency 
    H12 = findL2(H11);% find H2 given H1
    K_L_1 = 1/(L11*L12); % calculating the normalization coefficent 
    K_H_1 = 1/(H11*H12); % calculating the normalization coefficent 
    ts = 1/F_s; % sampling time 
    
    %%% find the transfer function
    z = tf('z',ts); 
    fl = 3.1626*z^(-((L11+L12)/2)+1)*(z^(-((H11+H12)/2)+1)-K_H_1*DRRS_tf_Z(H11,H12,F_s));
    fb = Gain*(K_H_1*(z^(-((L11+L12)/2)+1))*DRRS_tf_Z(H11,H12,F_s) - K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s));
    fh = 0.3162*K_L_1*z^(-((H11+H12)/2)+1)*DRRS_tf_Z(L11,L12,F_s);
end 

function DRRS = DRRS_tf_Z(L1,L2,F_s)
    %=================================================
    % DRRS transfer function
    % 
    % Parameters
    % L1 : scalar 
    %   The first calculating factor 
    % L2 : scalar
    %   The second calculating factor 
    % F_s : scalar
    %   The smapling frequency of the input data
    %
    %=================================================
    numerator1 = [1, zeros(1, L1-1), -1]; % define nurmerator of the tranfer function 
    numerator2 = [1, zeros(1, L2-1), -1]; % define anpther nurmerator of the tranfer function 
    numeratorT = conv(numerator1, numerator2); % apply convolution 
    denominator1 = [1, -1, zeros(1, L1-1)]; % define denomerator of the tranfer function 
    denominator2 = [1, -1, zeros(1, L2-1)]; % define another denomerator of the tranfer function
    denominatorT = conv(denominator1,denominator2);% apply convolution
    ts = 1/F_s;% sampling time 
    DRRS = tf(numeratorT,denominatorT,ts,'Variable','z');% find the transfer function
end 

% this function can find the desired L1 value
function L1 = FindL1(fc, F_s)
    %=================================================
    % Find L1 algorithm
    % 
    % Parameters
    % fc : scalar 
    %   cut-off frequency 
    % F_s : scalar
    %   The smapling frequency of the input data
    %
    %=================================================
    closestDistTo0_5=inf;% initlize the threshold 
    foundL1 = 0;% initlize the foundL1 
    upper = 1/(fc/F_s)+1; % define the upper bound for the for loop
    for i=1:2:upper
        j = findL2(i); % find L2 given i
        DRRS_mag = abs(DRRS_W(i,j,fc,F_s)); % compute the magnitude of the frequency response 
        DistTo0_5 = abs(DRRS_mag - 0.5); % compute the difference between the magnitue of the frequancy response and 0.5
        %%% to find the closest differences 
        if DistTo0_5 < closestDistTo0_5
            closestDistTo0_5 = DistTo0_5;
            foundL1 = i;
        end 
    end 
    L1 = foundL1; % found L1 
end

function DRRS = DRRS_W(L1,L2,fc,F_s)
    %=================================================
    % freqency response algorithm 
    % 
    % Parameters
    % L1 : scalar 
    %   The first calculting factor
    % L2 : scalar 
    %   The second calculting factor
    % fc : scalar 
    %   cut-off frequency
    % F_s : scalar 
    %   sampling frequency of the input data 
    %
    %=================================================
    temp = pi*fc/F_s; 
    DRRS = (exp(-2*1i*temp*(L1+L2-2)))*(sin(temp*L1)*sin(temp*L2))/(sin(temp)*sin(temp)*L1*L2);
end 

function L2 = findL2(L1)
    %=================================================
    % Find L2 algorithm
    % 
    % Parameters
    % L1 : scalar 
    %   The first calculting factor
    %
    %=================================================
   temp = round(L1/sqrt(2));
   if mod(temp,2) == 0
       L2 = temp+1;
   else 
       L2=temp;
   end
end 