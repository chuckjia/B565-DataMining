%% Accuracy evaluation
clc
filename = 'iris.csv';
nrestart = 20;
nclust = 3;
dist_fcn_no = 1;

err_rates = zeros(nrestart, 1);
for i = 1:nrestart
    err_rates(i) = evaluation(filename, nclust, 2, dist_fcn_no);  % filename, nclust, method_no, dist_fcn_no
end
min(err_rates)

%%

clc
rng(2500)  % 3,20/10000, 100/2000
runtime_test(1, 100)




%%

fileID = fopen("birch1.txt",'r');
dset = fscanf(fileID, "%f");
fclose(fileID);

[nrow, ncol] = size(dset);
dset = [dset(1:2:nrow) dset(2:2:nrow)];

csvwrite("birch1.csv", dset)





%%

runtime_standard











