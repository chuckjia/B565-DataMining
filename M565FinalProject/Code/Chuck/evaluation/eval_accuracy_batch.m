function accuracyArr = eval_accuracy_batch(outerFolder, thrArr, fileNumLimit, predFolderName, trueFolderName)
%EVALUATE Perform evaluation on the predicted masks

if nargin < 2
    fprintf("Not enough input!\n");
    return
end

if nargin < 5
    trueFolderName = 'masks';
    if nargin < 4
        predFolderName = 'trueprediction_images';
        if nargin < 3
            fileNumLimit = 9e20;
        end
    end
end

if fileNumLimit <= 0  % fileNumLimit <= 0 means no limit on number of files
    fileNumLimit = 9e20;
end

allSubFolders = listSubfolders(outerFolder);
numSubFolders = min(length(allSubFolders), fileNumLimit);

allIOU = cell(numSubFolders, 1);

for folderNo = 1:numSubFolders
    fprintf("Reading images from folder no. %d out of %d folders\n", folderNo, numSubFolders);
    fprintf("Folder = %s\n", allSubFolders{folderNo});
    
    trueFolder = fullfile(outerFolder, allSubFolders{folderNo}, trueFolderName);
    predFolder = fullfile(outerFolder, allSubFolders{folderNo}, predFolderName);
    
    iouBatch = calcIOU_batch(predFolder, trueFolder);
    allIOU{folderNo} = iouBatch;
end

numThr = length(thrArr);
accuracyArr = zeros(numThr, 1);

for thrNo = 1:numThr
    thr = thrArr(thrNo);
    fprintf("\nEvaluating with thr = %f\n", thr);
    accuracy = 0;
    
    for folderNo = 1:numSubFolders
        fprintf("Evaluating folder no. %d out of %d folders with thr = %f\n", folderNo, numSubFolders, thr);
        fprintf("Folder = %s\n", allSubFolders{folderNo});
        
        numTP = nnz(allIOU{folderNo} >= thr);
        
        predFolder = fullfile(outerFolder, allSubFolders{folderNo}, predFolderName);
        numFP = calcNumFilesInFolder(predFolder) - numTP;
        num_TP_FP_FN = length(allIOU{folderNo}) + numFP;
        
        accuracyCurr = numTP / num_TP_FP_FN;
        accuracy = accuracy + accuracyCurr;
        
        fprintf("Accuracy = %f\n", accuracyCurr);
    end
    
    accuracyArr(thrNo) = accuracy / numSubFolders;
end

fprintf("Completed. Mean accuracy = %f\n", mean(accuracyArr));

end







