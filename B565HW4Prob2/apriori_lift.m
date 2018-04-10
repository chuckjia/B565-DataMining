function F = apriori_lift( dset, candGenRule, minsup, minlift, itemNames )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 
% Frequent Itemset Generation
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 

[N, nitem] = size(dset);
minSuppCount = N * minsup;
F = cell(1, nitem);  % Collection of all frequent item sets
suppCountCache = cell(1, nitem);

fprintf(">> Association Rules Generation\n");
fprintf("  - %d Examples, %d Items\n", N, nitem);
fprintf("  - Min Support = %1.6f, Min Lift = %1.6f\n\n", minsup, minlift);

fprintf(">> Generating frequent itemsets using ");
if candGenRule == 1
    fprintf("F_{k-1} x F_1 method:\n");
else
    fprintf("F_{k-1} x F_{k-1} method:\n");
end

% ----- ----- ----- ----- ----- 
% Level 1 Candidates
% ----- ----- ----- ----- ----- 

levSuppCount_arr = sum(dset);
F1_arr = find(levSuppCount_arr >= minSuppCount);
F1_size = length(F1_arr);

F{1} = num2cell(F1_arr);
suppCountCache{1} = num2cell(levSuppCount_arr);

fprintf("  - Level 1 completed: generated %d frequent itemsets.\n", F1_size);

% ----- ----- ----- ----- ----- 
% Higher Level Candidates
% ----- ----- ----- ----- ----- 

lev = 1;

while (lev < nitem && ~isempty(F{lev}))
    prev_lev = lev;
    lev = lev + 1;
    
    % Candidate Generation
    
    if (candGenRule == 1)  % "F_{k-1} x F_1" Rule 
        candSet = apriori_gen_1(F{prev_lev}, F1_arr); 
    else  % "F_{k-1} x F_{k-1}" Rule 
        candSet = apriori_gen_2(F{prev_lev});
    end  % End of candidate generation with two rules: "F_{k-1} x F_1" and "F_{k-1} x F_{k-1}"
    
    numCand = length(candSet);
    F{lev} = cell(1, numCand);  % For performance reasons, initialization is oversized, which is corrected later
    freqSetNo = 0;
    
    for candNo = 1:numCand
        suppCount = calcSuppCount(dset, candSet{candNo});
        if suppCount >= minSuppCount
            freqSetNo = freqSetNo + 1;
            F{lev}{freqSetNo} = candSet{candNo};
            suppCountCache{lev}{freqSetNo} = suppCount;
        end
    end
    
    F{lev} = F{lev}(1:freqSetNo);
    fprintf("  - Level %d completed: generated %d candidate itemsets and %d frequent itemsets.\n", ...
        lev, numCand, freqSetNo);
end


if isempty(F{lev})
    F = F(1:(lev - 1));
end

fprintf("\n");

% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 
% Rule Generation
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== 

numLev = length(F);
fprintf(">> Rules: \n");

for lev = 2:numLev
    numFreqSet = length(F{lev});
    for freqSetNo = 1:numFreqSet
        H1 = num2cell(F{lev}{freqSetNo});
        for setNo = 1:length(H1)
            antecedent = setdiff(F{lev}{freqSetNo}, H1{setNo});
            suppCount = suppCountCache{lev}{freqSetNo};
            conf = suppCount / calcSuppCount(dset, antecedent);
            lift = conf / calcSuppCount(dset, H1{setNo}) * N;
            if (lift >= minlift)
                printRule_lift(antecedent, H1{setNo}, suppCount / length(dset), lift, itemNames);
            end
        end
        ap_genrules_lift(F, suppCountCache, lev, freqSetNo, H1, dset, minlift, itemNames);
    end
end

end

