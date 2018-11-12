function numFiles = calcNumFilesInFolder( folderPath )
%LISTFILESINFOLDER Summary of this function goes here
%   Detailed explanation goes here

allFiles = dir(folderPath);
allFiles = {allFiles(:).name};
toDelete = ismember(allFiles, {'.', '..', '.DS_Store'});
numFiles = length(allFiles) - nnz(toDelete);

end

