function F = apriori_freqset( dset, minsup, candGenRule )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 
% Frequent Itemset Generation
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 

[N, nitem] = size(dset);
minsupCount = N * minsup;
F = cell(1, nitem);  % Collection of all frequent item sets
suppCountCache = cell(1, nitem);

% ----- ----- ----- ----- ----- 
% Level 1 Candidates
% ----- ----- ----- ----- ----- 

levSuppCount = sum(dset);
suppCountCache{1} = num2cell(levSuppCount);
F1_arr = find(levSuppCount >= minsupCount);
F{1} = num2cell(F1_arr);
F1_size = length(F1_arr);

fprintf("- Level 1 completed: generated %d frequent itemsets.\n", F1_size);

% ----- ----- ----- ----- ----- 
% Higher Level Candidates
% ----- ----- ----- ----- ----- 

lev = 1;

while (lev < nitem && ~isempty(F{lev}))
    prev_lev = lev;
    lev = lev + 1;
    candNo = 0;
    F_prev_size = length(F{prev_lev});
    
    % Candidate Generation
    
    if (candGenRule == 1)  % "F_1 x F_{k-1}" Rule 
        
        candSet = cell(1, F_prev_size * F1_size);  % For better performance, initialization is oversized, which will be corrected later
        
        for i = 1:F_prev_size
            for j = F1_arr(F1_arr > max(F{prev_lev}{i}))  % Use lexicographical order to eliminate impossible candidates
                newCand = union(F{prev_lev}{i}, j);
                
                candNo = candNo + 1;
                candSet{candNo} = newCand;
            end
        end
        
    else  % "F_{k-1} x F_{k-1}" Rule 
        
        candSet = cell(1, F_prev_size * F_prev_size);
        equal_size = prev_lev - 1;
        
        for i = 1:F_prev_size
            for j = (i+1):F_prev_size
                if( F{prev_lev}{i}(prev_lev) ~= F{prev_lev}{j}(prev_lev) && ... 
                        isequal(F{prev_lev}{i}(1:equal_size), F{prev_lev}{j}(1:equal_size)) )
   
                    candNo = candNo + 1;
                    candSet{candNo} = union(F{prev_lev}{i}, F{prev_lev}{j});
                    
                end
            end
        end
        
    end  % End of candidate generation with two rules: "F_1 x F_{k-1}" and "F_{k-1} x F_{k-1}"
    
    numCand = candNo;
    F{lev} = cell(1, numCand);  % For performance reasons, initialization is oversized, which is corrected later
    freqSetNo = 0;
    
    for candNo = 1:numCand
        suppCount = sum(all(dset(:, candSet{candNo}), 2));
        if suppCount >= minsupCount
            freqSetNo = freqSetNo + 1;
            F{lev}{freqSetNo} = candSet{candNo};
            suppCountCache{lev}{freqSetNo} = suppCount;
        end
    end
    
    F{lev} = F{lev}(1:freqSetNo);
    fprintf("- Level %d completed: generated %d candidate itemsets and %d frequent itemsets.\n", ...
        lev, numCand, freqSetNo);
end


if isempty(F{lev})
    F = F(1:(lev - 1));
end

fprintf("\n");













% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 
% Rule Generation
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 

numLev = lev;

for lev = 1:numLev
    numFreqSet = length(F{lev});
    for setNo = 1:numFreqSet
        H
        F{lev}{setNo} 
        for m = 1:(lev - 2)
            
        end
    end
end


end

