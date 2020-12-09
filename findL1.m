%lets test our function below 
fc = 300;
F_s = 44100;
L1 = FindL1(fc, F_s)

% this function can find the desired L1 value
function L1 = FindL1(fc, F_s)
    closestDistTo0_5=inf;
    foundL1 = 0;
    upper = 1/(fc/F_s)+1
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
    L2 = round(L1/sqrt(2));
end 