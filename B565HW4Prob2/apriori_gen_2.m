function candSet = apriori_gen_2( H )
%AP_GENRULES_2 Summary of this function goes here
%   Detailed explanation goes here

H_size = length(H);
H_lev = length(H{1});

candSet = cell(1, floor(H_size * H_size / 2));

candNo = 0;
for i = 1:H_size
    for j = (i+1):H_size
        if (H{i}(H_lev) ~= H{j}(H_lev) && isequal(H{i}(1:end-1), H{j}(1:end-1)))
            candNo = candNo + 1;
            candSet{candNo} = union(H{i}, H{j});
        end
    end
end

candSet = candSet(1:candNo);

end

