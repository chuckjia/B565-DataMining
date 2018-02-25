function [labels, tot_err, itr_no] = kmeans(dset, nclust, dist_fcn) 
% kmeans: Computes clustering results using k-means algorithm
%   Input: - dset is an n x k matrix, which is treated as n vectors of dimension k.
%          - nclust is an integer which is the number of clusters
%          - dist_fcn is a function handle of the distance function to be used
%   Output: labels is a column vector of length n. labels(i) represents the cluster number for observation i

[nrow, ~] = size(dset);

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Initialization
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

% Forgy method
% Randomly choose nclust data points as centorids for initialization
centroids = dset(randsample(nrow, nclust),:);
labels = ones(nrow, 1);

% Random Partition method
% labels = randi([1, nclust], nrow, 1);
% centroids = zeros(nclust, ncol);

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% k-means 
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

itr_no = 0; prev_centroids = centroids + 1;
while (nnz(centroids - prev_centroids))
    if (itr_no > 10000) break; fprintf("Did not converge\n"); end
    itr_no = itr_no + 1;
    fprintf("Iteration No. %d\n", itr_no); 
    
    % Update membership
    for i = 1:nrow
        distances = dist_fcn(repmat(dset(i,:), nclust, 1), centroids);
        [~, labels(i)] = min(distances);
    end
    
    % Update centroids
    prev_centroids = centroids;
    
    empty_clusts = [];  % Used to track empty clusters
    for k = 1:nclust
        clust_pts = (labels == k);
        if sum(clust_pts) > 0
            centroids(k, :) = mean(dset(clust_pts,:));
        else
            empty_clusts = [empty_clusts, k];
        end
    end
    
    if ~isempty(empty_clusts)
        centroids(empty_clusts, :) = [];
        prev_centroids = centroids + 1;
        % prev_centroids(empty_clusts, :) = [];
        nclust = nclust - length(empty_clusts);
        
        uniq_labels = unique(labels);
        for i = 1:length(uniq_labels)
            labels(labels == uniq_labels(i)) = i;
        end
    end
end

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Calculate total error
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

tot_err = 0;
for i = 1:nrow
    tot_err = tot_err + dist_fcn(dset(i,:), centroids(labels(i),:)) .^ 2;
end

end





