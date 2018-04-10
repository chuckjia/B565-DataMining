function res = isMaximalFreq( freqSet, dset, minsup )
%ISMAXIMALFREQ Summary of this function goes here
%   Detailed explanation goes here

res = true;
[N, nitem] = size(dset);

for i = 1:nitem
    if (~ismember(i, freqSet))
        suppSuperSet = calcSuppCount(dset, union(freqSet, i)) / N;
        if suppSuperSet >= minsup
            res = false;
            break;
        end
    end
end

end

