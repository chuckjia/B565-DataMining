function dist = new_dist( x, y )
% new_dist: Calculates the distance between two vectors, using the new distance function in Eq. 1
%   This function can calculate distances between multiple pairs of vectors altogether.
%   Input: x and y as n x k matrices. Each matrix is treated as n vectors of dimension k. Distance between x(i,:) 
%          and y(i,:) will be calculated for all i
%   Output: A column vector dist. dist(i) is the distance between x(i,:) and y(i,:)

diff = x - y;
dist = sqrt(sum(max(diff, 0), 2) .^ 2 + sum(max(0, diff), 2) .^ 2);

end

