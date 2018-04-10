function count = countMaximalFreq( F, dset, minsup )
%COUNTMAXIMALFREQ Summary of this function goes here
%   Detailed explanation goes here

numLev = length(F);
count = 0;

for lev = 1:numLev
    numSet = length(F{lev});
    for setNo = 1:numSet
        if isMaximalFreq(F{lev}{setNo}, dset, minsup)
            count = count + 1;
        end
    end
end

end

