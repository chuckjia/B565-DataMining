function printRule_lift( set1, set2, supp, lift, itemNames )
%PRINTRULE Summary of this function goes here
%   Detailed explanation goes here

fprintf("  [ ");
fprintf("%s, ", itemNames(set1));
fprintf("] -> [ ");
fprintf("%s, ", itemNames(set2));
fprintf("], supp = %1.6f, lift = %1.6f\n", supp, lift);

end

