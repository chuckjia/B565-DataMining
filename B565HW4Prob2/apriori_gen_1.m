function candSet = apriori_gen_1( H, F1_arr )
%AP_GENRULES_1 Summary of this function goes here
%   Detailed explanation goes here

H_size = length(H);
candSet = cell(1, H_size * length(F1_arr));

candNo = 0;
for i = 1:H_size
    for j = F1_arr(F1_arr > max(H{i}))  % Use lexicographical order to eliminate impossible candidates
        newCand = union(H{i}, j);
        candNo = candNo + 1;
        candSet{candNo} = newCand;
    end
end

candSet = candSet(1:candNo);

end

