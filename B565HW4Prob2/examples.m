%%
clear; clc
dset = csvread("data/car_dv.csv"); 
itemNames = string(table2array(readtable("data/car_dv_names.csv",'ReadVariableNames',false)));


candGenRule = 2;
minsup = 0.1;
minconf = 0.9;
minlift = 1.5;

% F = apriori(dset, candGenRule, minsup, minconf, itemNames);
F = apriori_lift(dset, candGenRule, minsup, minlift, itemNames);
calcCountsScript

%%
clear; clc
dset = csvread("data/nursery_dv.csv"); 
itemNames = string(table2array(readtable("data/nursery_dv_names.csv", 'ReadVariableNames', false)));

candGenRule = 2;
minsup = 0.16;
minconf = 0.99;
minlift = 0.1;

% F = apriori(dset, candGenRule, minsup, minconf, itemNames);
F = apriori_lift(dset, candGenRule, minsup, minlift, itemNames);
calcCountsScript


%%
clear; clc
dset = csvread("data/mushroom_dv.csv"); 

candGenRule = 2;
minsup = 0.5;
minconf = 0.9;

F = apriori(dset, candGenRule, minsup, minconf);
calcCountsScript



%%








