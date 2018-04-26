%%

clear; clc

calcNumSeq(12, 5)


%%
clear; clc

syms n

nc1 = n / factorial(1);
nc2 = n * (n - 1) / factorial(2);
nc3 = n * (n - 1) * (n - 2) / factorial(3);
nc4 = n * (n - 1) * (n - 2) * (n - 3) / factorial(4);
nc5 = n * (n - 1) * (n - 2) * (n - 3) * (n - 4) / factorial(5);

f0 = 1;

f1 = n;

f2 = nc1 * f1 + nc2 * f0;

f3 = nc1 * f2 + nc2 * f1 + nc3 * f0;

f4 = nc1 * f3 + nc2 * f2 + nc3 * f1 + nc4 * f0;

f5 = nc1 * f4 + nc2 * f3 + nc3 * f2 + nc4 * f1 + nc5 * f0;

simplify(f5)

n = 12;
subs(f5)







