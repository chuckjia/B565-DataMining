function err_rate = evaluation(filename, nclust, method_no, dist_fcn_no)

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Read dataset and preprocess
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

dset = csvread(filename);
[nrow, ncol] = size(dset);
true_labels = dset(:, ncol);
ncol = ncol - 1; dset = dset(:, 1:ncol);

if (dist_fcn_no == 1)
    dist_fcn = @euclidean_dist;
elseif (dist_fcn_no == 2)
    dist_fcn = @cos_dist;
elseif (dist_fcn_no == 3)
    dist_fcn = @new_dist;
elseif (dist_fcn_no == 4)
    dist_fcn = @new_dist_normalized;
end

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Run k-means
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

tic
if (method_no == 2)
    [labels, err, tot_itr] = kmeans_elkan(dset, nclust, dist_fcn);
else
    [labels, err, tot_itr] = kmeans(dset, nclust, dist_fcn);
end
toc

% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Calculate error rate
% ===== ===== ===== ===== ===== ===== ===== ===== ===== =====

num_err = 0;
for k = 1:nclust
    clust_pts = (labels == k);
    clust_true_labels = true_labels(clust_pts);
    pred_label = mode(clust_true_labels);
    num_err = num_err + sum(clust_true_labels ~= pred_label);
end

err_rate = num_err / nrow * 100;
fprintf("Total error rate = %1.4f%%\n", err_rate);
fprintf("Total within cluster sum of square error = %f\n", err);

end