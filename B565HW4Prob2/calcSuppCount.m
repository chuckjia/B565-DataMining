function count = calcSuppCount( dset, itemset )
%CALCSUPPCOUNT Summary of this function goes here
%   Detailed explanation goes here

count = sum(all(dset(:, itemset), 2));

end

