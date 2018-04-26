%%
clear; clc
dset = csvread("data/car_dv.csv"); 
itemNames = string(table2array(readtable("data/car_dv_names.csv",'ReadVariableNames',false)));


candGenRule = 2;
minsup = 0.05;
minconf = 1;
minlift = 2.1;

% F = apriori(dset, candGenRule, minsup, minconf, itemNames);
F = apriori_lift(dset, candGenRule, minsup, minlift, itemNames);
calcCountsScript

%%
clear; clc
dset = csvread("data/nursery_dv.csv"); 
itemNames = string(table2array(readtable("data/nursery_dv_names.csv", 'ReadVariableNames', false)));

candGenRule = 2;
minsup = 0.15;
minconf = 0.99;
minlift = 3;

% F = apriori(dset, candGenRule, minsup, minconf, itemNames);
F = apriori_lift(dset, candGenRule, minsup, minlift, itemNames);
calcCountsScript


%%
clear; clc
dset = csvread("data/mushroom_dv.csv");
itemNames = string(table2array(readtable("data/mushroom_dv_names.csv", 'ReadVariableNames', false)));

candGenRule = 2;
minsup = 0.2;
minconf = 0.99;
minlift = 2.78;

% F = apriori(dset, candGenRule, minsup, minconf, itemNames);
F = apriori_lift(dset, candGenRule, minsup, minlift, itemNames);
calcCountsScript



%%








