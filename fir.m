% (1 - z^-L1) / (1 - z^-1) * (1- z^-L2) / (1 - z^-1) 
L1 = 75;
% L2 = L1/(sqrt(2))
L2 = 53;
% cut off frequency 
fc = 500;
% sampling frequency 
fs = 44100;

% den_exp = -exp(-2j*pi*(fc/fs));
% num_exp = -exp(-2j*pi*(fc/fs)*L1);
% num2_exp = -exp(-2j*pi*(fc/fs)*L2);

%z transform
% b1 = [1, zeros(1, L1-2), num_exp];
% b2 = [1, zeros(1, L2-2), num2_exp];
% a = [1, den_exp];
% 
% a=[1, -1]
% b1 = [1, 0, 0, ..., 0, -1]
% b2 = [1, 0, 0, ..., 0, -1]

% RRS function z-transfer equals to (1-z^(-L1))/(1-z^(-1))
% b is the numator of the z-transfermation of the RRS fuction 
b1 = [1, zeros(1, L1-2), -1];
b2 = [1, zeros(1, L2-2), -1];
bT = conv(b1,b2);
% a is the denumatior of the z-tranfer of the RRS fuction 
a = [1, -1];
aT = conv(a,a);

%%%%%%%%%%%%%%%%%%%%%%%%%
% freqz fives you the frequency response given b1 and a input 
% h is the frequency response vector and the w is the corresponding angular
% frequency
[hA, w1] = freqz(b1, a);
[hB, w] = freqz(b2, a);
[hT, wT] = freqz(bT, aT);
% here we have w1 and w are identical 

% cascaded system 
hAB = hA .* hB;

%plot((w*fs)/(2*pi), 20*log10(abs(hAB)))
%plot((w/pi), 20*log10(abs(hAB)))
plot((wT*fs)/(2*pi), 20*log10(abs(hT)))


xlabel('Frequency')
ylabel('Magnitude (dB)')
title('Recursive filter with cut-off = 500Hz') 


