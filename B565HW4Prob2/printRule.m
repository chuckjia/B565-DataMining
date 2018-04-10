function printRule( set1, set2, supp, conf, itemNames )
%PRINTRULE Summary of this function goes here
%   Detailed explanation goes here

fprintf("  [ ");
fprintf("%s, ", itemNames(set1));
fprintf("] -> [ ");
fprintf("%s, ", itemNames(set2));
fprintf("], supp = %1.6f, conf = %1.6f\n", supp, conf);

end

