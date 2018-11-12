copy_mask: copy the image in the subfolder 'image' and paste them in 'image's parent folder
 
CombineMask: combine given masks in one graph named 'combine.png'

premask_labeled: generate predicted masks on training data, result in a folder of true masks and a folder of false masks

premask: generate candidate masks on test set, result in a folder of predicted masks

on train set, run in the following order :
1. copy_mask.m 
2. CombineMask.m
3. premask_labeled.m

on test set, run in the following order:
1. copy_mask.m
2. load ‘test1.mat’
3. premasknew.m