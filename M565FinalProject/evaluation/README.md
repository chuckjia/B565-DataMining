# How To Run Evaluations

In this folder, the MATLAB function eval_accuracy calculates the accuracy of the predictions. The following command gives you the accuracy between images in "FinalPredict" and "masks".

`accuracy = eval_accuracy(outerFolder, thr, 0, 'FinalPredict', 'masks');`

For more examples, check out the files `Eg1_*.m`, `Eg2_*.m`, ... files.