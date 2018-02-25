function runtime_test(method_no, nclust)

fileID = fopen("birch1.txt",'r');
dset = fscanf(fileID, "%f");
fclose(fileID);

[nrow, ncol] = size(dset);
dset = [dset(1:2:nrow) dset(2:2:nrow)];

tic
if (method_no == 2)
    labels = kmeans_elkan(dset, nclust, @euclidean_dist);
else
    labels = kmeans(dset, nclust, @euclidean_dist);
end
toc

end