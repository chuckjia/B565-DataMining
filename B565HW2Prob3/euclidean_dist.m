function dist = euclidean_dist( x, y )
%ECLIDEAN_DIST Summary of this function goes here
%   Detailed explanation goes here

diff = x - y;
% dist = sqrt(diff * diff');
dist = sqrt(dot(diff, diff, 2));

end
