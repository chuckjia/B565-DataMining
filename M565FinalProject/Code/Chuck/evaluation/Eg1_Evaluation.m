outerFolder = '/Users/chuckjia/Documents/Workspace/DataStorage/B565/Results/stage1_test_unetv3_toy';
thrArr = [0.4] %, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7];

numThr = length(thrArr);
accuracyArr = zeros(1, numThr);

for i = 1:numThr
    thr = thrArr(i);
    fprintf("Currently using thr = %f\n", thr);
    accuracyArr(i) = eval_accuracy(outerFolder, thr, 0, 'predicted', 'masks');
end