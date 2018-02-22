clear; clc;

fileID = fopen("birch1.txt",'r');
dset = fscanf(fileID, "%f");
fclose(fileID);

[nrow, ncol] = size(dset);
dset = [dset(1:2:nrow) dset(2:2:nrow)];


tic
nclust = 100;
labels = kmeans_elkan(dset, nclust, @euclidean_dist);
% labels = kmeans(dset, nclust, @euclidean_dist);
toc