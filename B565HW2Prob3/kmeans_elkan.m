function [labels, tot_err, itr_no] = kmeans_elkan( dset, nclust, dist_fcn )
% kmeans_elkan: Computes clustering results using k-means algorithm with Elkan acceleration
%   Input: - dset is an n x k matrix, which is treated as n vectors of dimension k.
%          - nclust is an integer which is the number of clusters
%          - dist_fcn is a function handle of the distance function to be used
%   Output: labels is a column vector of length n. labels(i) represents the cluster number for observation i

[nrow, ~] = size(dset);

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Initialization
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

% Randomly choose nclust data points as centorids for initialization
centroids = dset(randsample(nrow, nclust),:);
labels = ones(nrow, 1);
for i = 1:nrow
    distances = dist_fcn(repmat(dset(i,:), nclust, 1), centroids);
    [~, labels(i)] = min(distances);
end
upper_bd = repmat(realmax, nrow, 1);
lower_bd = zeros(nrow, nclust);

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% k-means with Elkan acceleration 
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

% This is an implementation of Algorithm 3 on page 55 of "Accelerating Lloyd's Algorithm for k-Means Clustering" by
% Greg Hamerly and Jonathan Drake. 

itr_no = 0; prev_centroids = centroids + 1;
while (nnz(centroids - prev_centroids))
    if (itr_no > 10000) break; fprintf("Did not converge\n"); end
    itr_no = itr_no + 1;
    fprintf("Iteration No. %d\n", itr_no); 
    
    between_centr_dist = repmat(realmax, nclust, nclust);  % Stores result of line 5 calculation in Algorithm 3
    for i = 1:(nclust - 1)
        for j = (i + 1) : nclust
            distance = dist_fcn(centroids(i, :), centroids(j, :));
            between_centr_dist(i, j) = distance;
            between_centr_dist(j, i) = distance;
        end
    end
    
    s_dist = min(between_centr_dist) * 0.5;  % s(i) function in Algorithm 3
    
    for i = 1:nclust
        between_centr_dist(i, i) = 0;
    end
    
    for i = 1:nrow  % Loop on line 7 in Algorithm 3
        if upper_bd(i) <= s_dist(labels(i))  
            continue;  
        end
        
        recalc = true;  % r on line 9 in Algorithm 3
        for j = 1:nclust  % Loop on line 10 in Algorithm 3
            curr_label = labels(i);
            if j == curr_label 
                continue; 
            end
            z = max(lower_bd(i, j), between_centr_dist(curr_label, j) * 0.5);  % Algorithm line 11: z
            if upper_bd(i) <= z 
                continue; 
            end
            
            if recalc
                new_upper_bd = dist_fcn(dset(i,:), centroids(curr_label,:));
                upper_bd(i) = new_upper_bd;
                recalc = false;
                if new_upper_bd <= z 
                    continue; 
                end
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
    empty_clusts = [];  % Used to track empty clusters
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
    
    if ~isempty(empty_clusts)
        prev_centroids = centroids + 1;
    end
    
    upper_bd = upper_bd + delta(labels);
    
    lower_bd = max(0, lower_bd - delta');
end

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Calculate total within cluster squared error
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

tot_err = 0;
for i = 1:nrow
    tot_err = tot_err + dist_fcn(dset(i,:), centroids(labels(i),:)) .^ 2;
end

end

