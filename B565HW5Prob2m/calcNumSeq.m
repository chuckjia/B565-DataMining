function numSeq = calcNumSeq(n, k)
%CALCNUMSEQ Summary of this function goes here
%   Detailed explanation goes here

if (n < k || k > 100)
    error('Invalid input!')
end

global cache
cache = repmat(-1, 1, 20);

numSeq = calcNumSeqHelper(n, k);

end

