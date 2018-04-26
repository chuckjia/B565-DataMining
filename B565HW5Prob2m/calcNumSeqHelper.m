function numSeq = calcNumSeqHelper(n, k)
%CALCNUMSEQ Summary of this function goes here
%   Detailed explanation goes here

global cache

if k == 0
    numSeq = 1;
    return;
end

numSeq = cache(k);
if numSeq >= 0
   return;
end

numSeq = 0;
for i = 1:k
    numSeq = numSeq + nchoosek(n, i) * calcNumSeqHelper(n, k - i);
end

cache(k) = numSeq;

end

