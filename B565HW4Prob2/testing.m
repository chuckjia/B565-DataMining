clear; clc

dset = ...
    [1 1 0 0 0 0;
    1 0 1 1 1 0;
    0 1 1 1 0 1;
    1 1 1 1 0 0;
    1 1 1 0 0 1]

tic
cand = apriori(dset, 1, 0.2, 0);
toc

printFreqSets(cand);


%%
clear; clc

tic
n = 100000;
c = {};
for i = 1:n
    c{end + 1} = [1, 2];
end
toc





%%
clear; clc

tic
n = 100000;
c = cell(1, n);
for i = 1:n
    c{i} = [1, 2];
end
toc





%%
clear; clc

tic
n = 1000000000;
c = zeros(1, n);
toc



%%
clear; clc

tic

c = {{[1, 2], 3, 'a'}, {'b', 'a'}, [3,4,5]};

n = 100
for i = 1:n
    length(c{mod(i, 3) + 1})
end

toc

%%

for i = [3,5,6,9]
    i
end



%%

arr = [1, 2, 3];
c{1} = num2cell(arr);
c




%%

clear; clc

c = cell(1, 3)

c(2) = []




%%

clear; clc
tic
n = 3;
if (n == 2)
    cand = 1;
else
    cand = 2;
end
cand
toc

%%

clear; clc

rules = cell(1, 3)

rules{1} = {1, 2}


%%

a = [1, 2, 3, 4; 4, 5, 6, 7; 2, 3, 4, 5; 1, 0, 0, 0]
a(2:3, 2:3)


%%
for i = 1:-2
    x = 1
end


%%
clear; clc

a = cell(1,100);
a{1} = [1,2];
a{2} = [3,4];
endval = 4;

tic
for i = 1:1e6
    a = cell(1,100);
    a(1:50)=[];
end
toc

%%

clc
a = [1, 0; 0, 1; 1, 1]
all(a, 2)


%%
clear; clc

rules = cell(1, 3);

rules{1} = {1, 2};
rules{2} = {3, 5, 7};
rules{3} = {2, 3};

printFreqSets(rules);

rules = rules([true, false, true])
printFreqSets(rules);





%%
clc
dset = csvread("car_dv.csv"); 

load Karate
apriori(dset, 2, 0.1, 0.7);

minSup = 0.1;
minConf = 0.7;
nRules = 100;
sortFlag = 1;
fname = 'car';
for s = 1:size(dset, 2)
    labels{s} = [num2str(s)];
end
[Rules FreqItemsets] = findRules(dset, minSup, minConf, nRules, sortFlag, labels, fname);


%%
clear; clc
dset = csvread("car_dv.csv"); 
apriori(dset, 1, 0.2, 0.5);












































