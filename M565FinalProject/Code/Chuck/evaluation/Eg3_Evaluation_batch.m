outerFolder = '/Users/chuckjia/Documents/Workspace/DataStorage/B565/Results/stage1_test_unetv3';
thrArr = [0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95];

tic
predFolderName = 'predicted';
accuracyArr = eval_accuracy_batch(outerFolder, thrArr, 0, predFolderName, 'masks');
toc

accuracyArr