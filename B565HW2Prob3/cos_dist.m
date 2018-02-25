function dist = cos_dist( x, y )
% cos_dist: Calculates the cosine distance between two vectors
%   This function can calculate distances between multiple pairs of vectors altogether.
%   Input: x and y as n x k matrices. Each matrix is treated as n vectors of dimension k. Distance between x(i,:) 
%          and y(i,:) will be calculated for all i
%   Output: A column vector dist. dist(i) is the distance between x(i,:) and y(i,:)

dist = 1 - dot(x, y, 2) ./ (dot(x, x, 2) .* dot(y, y, 2));

end

