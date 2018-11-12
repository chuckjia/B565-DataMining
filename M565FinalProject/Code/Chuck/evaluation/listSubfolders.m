function allFolders = listSubfolders( outerFolder )
%LISTSUBFOLDERS List all the subfolders under a folder
%   This script is intended for MacOS High Sierra
%   Return type: cell array

allFolders = dir(outerFolder);

isDir = [allFolders(:).isdir];
allFolders = {allFolders(isDir).name};

toDelete = ismember(allFolders, {'.', '..'});
allFolders(toDelete) = [];

end

