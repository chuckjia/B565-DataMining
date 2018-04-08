function H_new = ap_genrules( freqSet, H )
%AP_GENRULES Summary of this function goes here
%   Detailed explanation goes here

k = length(freqSet);
m = length(H{1});
H_size = length(H);

if k > m + 1
    
    H_new = cell(1, H_size * H_size);
    equal_size = m - 1;
    candNo = 0;
    for i = 1:H_size
        for j = (i+1):H_size
            if (H{i}(m) ~= H{j}(m) && isequal(H{i}(1:equal_size), H{j}(1:equal_size)))
                candNo = candNo + 1;
                H_new{candNo} = union(H{i}, H{j});
            end
        end
    end
    
    H_new = H_new(1:candNo);
    
end

end

