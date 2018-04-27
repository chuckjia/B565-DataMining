outerFolder = '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_train';

imgDir = fullfile(outerFolder, '*', 'images');
images = imageDatastore(imgDir);

imgDir = fullfile(outerFolder, '*', 'singleMask');
masks = imageDatastore(imgDir);

imgNo = 3;
I = readimage(images, imgNo);
imshow(I)
C = readimage(masks, imgNo);
figure
imshow(C)
B = labeloverlay(I, C);
figure
imshow(B)

%%

outerFolder = '/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/M565FinalProject/Packages/svm/stage1_train/';
innerFolder = '0a7d30b252359a10fd298b638b90cb9ada3acced4e0c0e5a3692013f432ee4e9/trueprediction_images/';
filename = fullfile(outerFolder, innerFolder, 'truepredict_2.png');
mask1 = imread(filename);

innerFolder = '0a7d30b252359a10fd298b638b90cb9ada3acced4e0c0e5a3692013f432ee4e9/masks/';
filename = fullfile(outerFolder, innerFolder, 'a786c895f69343a4da7b368b853ac82fb436da7225d26d8c75e30db64f2fdad5.png');
mask2 = imread(filename);

calcIOU(mask1, mask2)

%%

outerFolder = '/Users/chuckjia/Documents/Workspace/Git/B565-DataMining/M565FinalProject/Packages/svm/stage1_train';
result = evaluate(outerFolder, 0.3, 10);
result

%%

clear; clc
file1 = '/Users/chuckjia/Documents/Workspace/DataStorage/B565/Results/stage1_test_ver4/7bdb668e6127b7eafc837a883f0648002bd063c736f55a4f673e787250a3fb04/singleMask/single_mask.png';
A = imread(file1);
imshow(A)
[nrow, ncol, ~] = size(A);

file2 = '/Users/chuckjia/Documents/Workspace/DataStorage/B565/Results/stage1_test_ver4/7bdb668e6127b7eafc837a883f0648002bd063c736f55a4f673e787250a3fb04/pred_single_mask/47.png';
B = imread(file2);
%figure
% imshow(B)
C = imresize(B, [nrow ncol]);

figure
imshow(C)






