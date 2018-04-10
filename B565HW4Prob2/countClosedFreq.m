function count = countClosedFreq( F, dset )
%COUNTCLOSDFREQ Summary of this function goes here
%   Detailed explanation goes here

numLev = length(F);
count = 0;

for lev = 1:numLev
    numSet = length(F{lev});
    for setNo = 1:numSet
        if isClosedFreq(F{lev}{setNo}, dset)
            count = count + 1;
        end
    end
end

end

