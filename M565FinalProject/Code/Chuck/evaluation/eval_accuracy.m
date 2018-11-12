function accuracy = eval_accuracy(outerFolder, thr, fileNumLimit, predFolderName, trueFolderName)
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

accuracy = 0;
for folderNo = 1:numSubFolders
    fprintf("Working on %d out of %d folders.\n", folderNo, numSubFolders);
    fprintf("Folder = %s\n", allSubFolders{folderNo});
    
    trueFolder = fullfile(outerFolder, allSubFolders{folderNo}, trueFolderName);
    predFolder = fullfile(outerFolder, allSubFolders{folderNo}, predFolderName);
    
    iouBatch = calcIOU_batch(predFolder, trueFolder);
    numTP = nnz(iouBatch >= thr);
    numFP = max(length(dir(predFolder)) - numTP - 3, 0);
    num_TP_FP_FN = length(iouBatch) + numFP;
    accuracyCurr = numTP / num_TP_FP_FN;
    
    accuracy = accuracy + accuracyCurr;
    
    fprintf("Accuracy = %f\n", accuracyCurr);
end

accuracy = accuracy / numSubFolders;

fprintf("Completed. Mean accuracy = %f\n", accuracy);

end







