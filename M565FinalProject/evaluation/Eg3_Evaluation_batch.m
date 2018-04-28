outerFolder = '/Users/chuckjia/Documents/Workspace/DataStorage/B565/Results/stage1_test_unetv3';
thrArr = [0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7];

tic
accuracyArr = eval_accuracy_batch(outerFolder, thrArr, 0, 'predicted', 'masks');
toc