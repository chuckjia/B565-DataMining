function ap_genrules( F, suppCountCache, lev, freqSetNo, H, dset, minconf, itemNames )
%AP_GENRULES Summary of this function goes here
%   Detailed explanation goes here

m = length(H{1});

if (lev > m + 1)
    H_new = apriori_gen_2(H);
    H_new_size = length(H_new);
    H_select = repmat(true, H_new_size, 1);
    
    for setNo = 1:H_new_size
        itemset = setdiff(F{lev}{freqSetNo}, H_new{setNo});
        suppCount = suppCountCache{lev}{freqSetNo};
        conf =  suppCount / calcSuppCount(dset, itemset);
        
        if conf >= minconf
            printRule(itemset, H_new{setNo}, suppCount / length(dset), conf, itemNames);
        else
            H_select(setNo) = false;
        end
    end
    
    if (nnz(H_select) > 0)
        ap_genrules(F, suppCountCache, lev, freqSetNo, H_new(H_select), dset, minconf, itemNames);
    end
end

end

