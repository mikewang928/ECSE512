%DRRS_tf_Z will return a z-domain transfer function of a single DRRS
%function successfully 


% testing 
testTF = DRRS_tf_Z(71,53,44100)
% extract the coeificent from the tranfer function
[num, dem] = tfdata(testTF)
% comvert the tranfer function into a dlit filter object
[s,g] = zp2sos(cell2mat(num),cell2mat(dem),1);
hf = dfilt.df2sos(s,g);
fvtool(hf)

%remember to add the normalization gain of (1/L1/L2) 
% input: 
%       L1: the first data length
%       L2: the second data length (L1/(sqrt(2))
%       F_s: sampling frequency (must be consistance with the actual frequency of the sampling frequency of the original wav file)
% Output: 
%       DRRS: z-domain transfer function

function DRRS = DRRS_tf_Z(L1,L2,F_s)
    numerator1 = [1, zeros(1, L1-1), -1];
    numerator2 = [1, zeros(1, L2-1), -1];
    numeratorT = conv(numerator1, numerator2);
    denominator = [1, -1];
    ts = 1/F_s;
    DRRS = 1/L1/L2*tf(numeratorT,denominator,ts,'Variable','z^-1');
end 

 



