function F = apriori_freqset( dset, minsup )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[N, nitem] = size(dset);
minsupCount = N * minsup;
F = cell(1, nitem);  % Collection of all frequent item sets

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Level 1 candidates
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

F1_arr = find(sum(dset) >= minsupCount);
F{1} = num2cell(F1_arr);

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Higher level candidates: F_1 x F_{k-1} rule
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

F1_size = length(F1_arr);
lev = 1;

while (lev < nitem && ~isempty(F{lev}))
    candSet = cell(1, length(F{lev}) * F1_size);  % For performance reasons, initialization is oversized, which is corrected later

    prev_lev = lev;
    lev = lev + 1;
    candNo = 0;
    
    for i = 1:length(F{prev_lev})
        itemset = F{prev_lev}{i};
        for j = F1_arr(F1_arr > max(itemset))  % Use lexicographical order to eliminate impossible candidates
            newCand = union(itemset, j);
            candNo = candNo + 1;
            candSet{candNo} = newCand;
        end
    end
    
    numCand = candNo;
    F{lev} = cell(1, numCand);  % For performance reasons, initialization is oversized, which is corrected later
    freqItemsetNo = 0;
    
    for candNo = 1:numCand
        if sum(all(dset(:, candSet{candNo}), 2)) >= minsupCount
            freqItemsetNo = freqItemsetNo + 1;
            F{lev}{freqItemsetNo} = candSet{candNo};
        end
    end
    
    F{lev} = F{lev}(1:freqItemsetNo);
    fprintf("- Level %d completed: %d candidate itemsets are generated.\n", lev, candNo);
end

if isempty(F{lev})
    F = F(1:(lev - 1));
end

end

