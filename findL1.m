% round to nearest integer https://www.mathworks.com/matlabcentral/answers/45932-round-to-nearest-odd-integer
function y = odd_round(x)
    y = 2*floor(x/2)+1;
end

function freqresp = func(f, L1, T)
    % assuming YangA, then 1.5 as denominator
    L2=odd_round(L1/1.5);
    % assuming YangA DRRS frequency response (since YangB's is different)
    freqresp=exp((-2*1j*pi*f*T)*(L1+L2-2))*L1*L2*sin(pi*f*T*L1)*sin(pi*f*T*L2)/(sin(pi*f*T).^2);
end


% bool=0;
L1=0;
i=3;
% while (i<(T/fL+1) & (bool==0):
%     if func(fL, i, T)=0.5
%         L1=i;
%         bool=1;
%     i=i+1;

% without bool
while i<(T/fL+1):
    if abs(func(fL, i, T))==0.5
        L1=i;
        i=(T/fL+1);
    i=i+1;

