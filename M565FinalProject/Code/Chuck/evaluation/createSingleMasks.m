function createSingleMasks(outerFolder, newFolder)
%CREATESINGLEMASKS Combine all cell masks in one single binary mask file
%   This function combines all the binary mask files for a train image and outputs a single masks showing the
%   locations of all cell nuclei

if nargin == 1
    newFolder = 'singleMask'
end

allFolders = listSubfolders(outerFolder);
numFolders = length(allFolders);

progBar = waitbar(0, 'Creating single masks...');
titleHandle = get(findobj(progBar, 'Type', 'axes'),'Title'); set(titleHandle, 'FontSize', 12);
progMsg_part = strcat({' out of '}, {num2str(numFolders)}, {' Completed ('});

for folderNo = 1:numFolders
    currProg = folderNo / numFolders;
    waitMsg = strcat(num2str(folderNo),  progMsg_part, num2str(round(currProg * 100, 2)), '%)');
    waitbar(currProg, progBar, waitMsg);
    
    maskFolderName = fullfile(outerFolder, allFolders{folderNo}, 'masks');
    imds = imageDatastore(maskFolderName);
    numImg = length(imds.Files);
    
    singleMask = readimage(imds, 1);
    for imgNo = 2:numImg
        singleMask = singleMask | readimage(imds, imgNo);
    end
    
    newFolderPath = fullfile(outerFolder, allFolders{folderNo}, newFolder);
    if (~exist(newFolderPath))
        mkdir(newFolderPath);
    end
    newFilename = fullfile(outerFolder, allFolders{folderNo}, newFolder, 'single_mask.png');
    imwrite(singleMask, newFilename);
end

close(progBar);

end

