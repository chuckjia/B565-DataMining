function resizeMask( outerFolder, newFolder )
%RESIZEMASK Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    newFolder = 'pred_mask_resized'
end

allFolders = listSubfolders(outerFolder);
numFolders = length(allFolders);

progBar = waitbar(0, 'Risizing predicted masks...');
titleHandle = get(findobj(progBar, 'Type', 'axes'),'Title'); set(titleHandle, 'FontSize', 12);
progMsg_part = strcat({' out of '}, {num2str(numFolders)}, {' Completed ('});

for folderNo = 1:numFolders
    currProg = folderNo / numFolders;
    waitMsg = strcat(num2str(folderNo),  progMsg_part, num2str(round(currProg * 100, 2)), '%)');
    waitbar(currProg, progBar, waitMsg);
    
    imgFolderName = fullfile(outerFolder, allFolders{folderNo}, 'images');
    imds = imageDatastore(imgFolderName);
    
    imgSize = size(readimage(imds, 1));
    
    imgFolderName = fullfile(outerFolder, allFolders{folderNo}, 'pred_single_mask');
    imds = imageDatastore(imgFolderName);
    newMask = readimage(imds, 1);
    
    newFolderPath = fullfile(outerFolder, allFolders{folderNo}, newFolder);
    if (~exist(newFolderPath))
        mkdir(newFolderPath);
    end
    newMask = imresize(newMask, [imgSize(1), imgSize(2)]);
    newFilename = fullfile(outerFolder, allFolders{folderNo}, newFolder, 'pred_mask_resized.png');
    imwrite(newMask, newFilename);
end

close(progBar);

end

