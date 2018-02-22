function labels = kmeans(dset, nclust, dist_fcn) 

[nrow, ncol] = size(dset);

% Randomly choose nclust data points as centorids for initialization
centroids = dset(randsample(nrow, nclust),:);
labels = zeros(nrow, 1);

% Random labeling
% labels = randi([1, nclust], nrow, 1);
% centroids = zeros(nclust, ncol);

itr_no = 0; prev_centroids = centroids + 1;

while (nnz(centroids - prev_centroids))
    itr_no = itr_no + 1;
    fprintf("Iteration No. %d\n", itr_no); 
    
    % Update membership
    for i = 1:nrow
        distances = dist_fcn(repmat(dset(i,:), nclust, 1), centroids);
        [~, labels(i)] = min(distances);
    end
    
    % Update centroids
    prev_centroids = centroids;
    
    empty_clusts = [];
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
        nclust = nclust - length(empty_clusts);
        prev_centroids = centroids + 1;
    end
end

obj_fcn_val = 0;
for i = 1:nrow
    obj_fcn_val = obj_fcn_val + dist_fcn(dset(i,:), centroids(labels(i),:));
end

end





