
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












