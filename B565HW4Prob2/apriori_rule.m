function [ output_args ] = apriori_rule( F )
%APRIORI_RULEGEN Summary of this function goes here
%   Detailed explanation goes here

numLev = length(F);
for lev = 1:numLev
    numFreqSet = length(F{lev});
    for setNo = 1:numFreqSet
        for m = 1:(lev - 1)
            F{lev}{setNo}
        end
    end
end

end

