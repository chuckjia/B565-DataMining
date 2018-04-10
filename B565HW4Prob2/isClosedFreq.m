function res = isClosedFreq( freqSet, dset )
%ISFREQCLOSED Summary of this function goes here
%   Detailed explanation goes here

res = true;
nitem = size(dset, 2);
suppCount = calcSuppCount(dset, freqSet);

for i = 1:nitem
    if (~ismember(i, freqSet))
        suppCountSuperSet = calcSuppCount(dset, union(freqSet, i));
        if suppCount == suppCountSuperSet
            res = false;
            break;
        end
    end
end


end

