function dist = euclidean_dist( x, y )
% euclidean_dist: Calculates the Euclidean distance between two vectors (2-norm distance)
%   This function can calculate distances between multiple pairs of vectors altogether.
%   Input: x and y as n x k matrices. Each matrix is treated as n vectors of dimension k. Distance between x(i,:) 
%          and y(i,:) will be calculated for all i
%   Output: A column vector dist. dist(i) is the distance between x(i,:) and y(i,:)

diff = x - y;
% dist = sqrt(diff * diff');  % Faster as vector product, but not compatible with matrices
dist = sqrt(dot(diff, diff, 2));

end

