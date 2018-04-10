function ap_genrules_lift( F, suppCountCache, lev, freqSetNo, H, dset, minlift, itemNames )
%AP_GENRULES Summary of this function goes here
%   Detailed explanation goes here

m = length(H{1});
N = length(dset);

if (lev > m + 1)
    H_new = apriori_gen_2(H);
    H_new_size = length(H_new);
    
    for setNo = 1:H_new_size
        antecedent = setdiff(F{lev}{freqSetNo}, H_new{setNo});
        suppCount = suppCountCache{lev}{freqSetNo};
        conf =  suppCount / calcSuppCount(dset, antecedent);
        lift = conf / calcSuppCount(dset, H_new{setNo}) * N;
        
        if lift >= minlift
            printRule_lift(antecedent, H_new{setNo}, suppCount / length(dset), lift, itemNames);
        end
    end
    
    ap_genrules_lift(F, suppCountCache, lev, freqSetNo, H_new, dset, minlift, itemNames);
end

end

