function count = countFreqItemsets( F )
%COUNTFREQITEMSETS Summary of this function goes here
%   Detailed explanation goes here

numLev = length(F);
count = 0;

for lev = 1:numLev
    count = count + length(F{lev});
end

end

