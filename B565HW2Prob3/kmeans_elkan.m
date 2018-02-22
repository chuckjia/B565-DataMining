function labels = kmeans_elkan( dset, nclust, dist_fcn )

[nrow, ncol] = size(dset);

% Randomly choose nclust data points as centorids for initialization
centroids = dset(randsample(nrow, nclust),:);
labels = ones(nrow, 1);
for i = 1:nrow
    distances = dist_fcn(repmat(dset(i,:), nclust, 1), centroids);
    [~, labels(i)] = min(distances);
end
upper_bd = zeros(nrow, 1); upper_bd(:) = realmax;
lower_bd = zeros(nrow, nclust);

% k-means
itr_no = 0; prev_centroids = centroids + 1;
while (nnz(centroids - prev_centroids))
    itr_no = itr_no + 1;
    fprintf("Iteration No. %d\n", itr_no); 
    
    between_centr_dist = repmat(realmax, nclust, nclust);  % Result of line 5 in algorithm
    for i = 1:(nclust - 1)
        for j = (i + 1) : nclust
            distance = dist_fcn(centroids(i, :), centroids(j, :));
            between_centr_dist(i, j) = distance;
            between_centr_dist(j, i) = distance;
        end
    end
    
    s_dist = min(between_centr_dist) * 0.5;  % s(i) function in algorithm
    
    
    
    
    
    
    for i = 1:nrow
        if upper_bd(i) <= s_dist(labels(i))  continue;  end
        
        recalc = true;
        for j = 1:nclust
            curr_label = labels(i);
            if j == curr_label continue; end
            z = max(lower_bd(i, j), between_centr_dist(curr_label, j));  % Algorithm line 11: z
            if upper_bd(i) <= z continue; end
            
            if recalc
                new_upper_bd = dist_fcn(dset(i,:), centroids(curr_label,:));
                upper_bd(i) = new_upper_bd;
                recalc = false;
                if new_upper_bd <= z continue; end
            end
            
            new_lower_bd = dist_fcn(dset(i,:), centroids(j,:));
            lower_bd(i, j) = new_lower_bd;
            if new_lower_bd < upper_bd(i)
                labels(i) = j;
            end
        end
    end
    
    
    % Update centroids
    prev_centroids = centroids;
    empty_clusts = [];
    for j = 1:nclust
        clust_pts = (labels == j);
        if sum(clust_pts) > 0
            centroids(j, :) = mean(dset(clust_pts,:));
        else
            empty_clusts = [empty_clusts, j];
        end
    end
    
    if ~isempty(empty_clusts)
        centroids(empty_clusts, :) = [];
        prev_centroids(empty_clusts, :) = [];
        lower_bd(:, empty_clusts) = [];
        nclust = nclust - length(empty_clusts);
        
        uniq_labels = unique(labels);
        for i = 1:length(uniq_labels)
            labels(labels == uniq_labels(i)) = i;
        end
    end
    
    delta = dist_fcn(centroids, prev_centroids);
    
    upper_bd = upper_bd + delta(labels);
    
    lower_bd = lower_bd - delta';
    
end


end


















