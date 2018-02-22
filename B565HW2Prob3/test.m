
tic
for i = 1:100000
    a = i + [1.0, 2.0];
    b = i + [3.5, 4.5];
    % c = dot(a, b);
    diff = a - b;
    c = dot(diff, diff);
end
toc

%%


a = [1,2; 1,2];
b = [2,3; 2,3];
diff = a - b;
sqrt(diff * diff')


%%
clc
a = [1; 2; 5; -2; 6];
[~, i] = min(a)


%%
repmat([1,2],2,1)


%%

clc
d = [1,2,5]';
l = [2,3,1,2,1];
d(l)


%%
clc

A = [1,2,3;4,5,6;7,8,9; 10, 11, 12]

diff = [1,1; 2,2];
dot(diff, diff, 2)


%%

A = [1,2,3;4,5,6;7,8,9; 10, 11, 12]
A - [0.5,0.1,0.2]


%%
clc
fileID = fopen("birch1.txt",'r');
A = fscanf(fileID, "%f");
fclose(fileID);








