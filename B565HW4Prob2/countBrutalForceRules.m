function count = countBrutalForceRules( F )
%COUNTBRUTALFORCERULES Summary of this function goes here
%   Detailed explanation goes here

numLev = length(F);
count = 0;

for lev = 1:numLev
    numSet = length(F{lev});
    count = count + numSet * (2 ^ lev - 2);
end

end

