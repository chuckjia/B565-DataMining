function printFreqsets( F )
%PRINTFREQSETS Summary of this function goes here
%   Detailed explanation goes here

numLev = length(F);
fprintf("This set has %d levels.\n", numLev);

for lev = 1:numLev
    numSet = length(F{lev});
    fprintf("\n- Level %d: \n", lev);
    for setNo = 1:numSet
        display(F{lev}{setNo});
    end
end

end

