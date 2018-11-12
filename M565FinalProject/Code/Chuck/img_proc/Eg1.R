rm(list = ls())
cat("\014")

##
# Create masks from ground truth
#    The following block will use the encoded ground truth CSV file to generate true masks for the 
#    test_stage_1 data set. All generated single cell masks will be stored in subfolder named 
#    newFolderName == 'masks'
#
setwd(dirname(rstudioapi::getSourceEditorContext()$path))  # Set the current work directory
source("createMaskFromGroundTruth.R")
outerFolder <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_test_testing';
groundTruthFile <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_solution.csv';
newFolderName <- 'masks'
createMaskFromGroundTruth(outerFolder, groundTruthFile, newFolderName)


##
# Create masks from an encoded file
#    The following block will use the encoded submission CSV file to generate masks for the 
#    test_stage_1 data set. All generated single cell masks will be stored in subfolder named 
#    newFolderName == 'predicted'
#
setwd(dirname(rstudioapi::getSourceEditorContext()$path))  # Set the current work directory
source("createMaskFromEncodedFile.R")
outerFolder <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_test_testing';
encodedFile <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/sub-dsbowl2018-1.csv';
newFolderName <- 'predicted'
createMaskFromEncodedFile(outerFolder, encodedFile, newFolderName)




(0.514722 + 0.560859 + 0.544509 + 0.487283 + 0.470382 + 0.451999 + 0.430135) / 7





