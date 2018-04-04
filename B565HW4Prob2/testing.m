clear; clc

dset = [1 1 0 0 0 0;
    1 0 1 1 1 0;
    0 1 1 1 0 1;
    1 1 1 1 0 0;
    1 1 1 0 0 1]

tic
cand = apriori(dset, 0.5);
toc

cand{1}
cand{2}


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












































































