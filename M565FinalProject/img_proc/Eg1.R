rm(list = ls())
cat("\014")

setwd(dirname(rstudioapi::getSourceEditorContext()$path))  # Set the current work directory

##
# Create masks from ground truth
#
source("createMaskFromGroundTruth.R")
outerFolder <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_test_testing';
groundTruthFile <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_solution.csv';
newFolderName <- 'masks'
createMaskFromGroundTruth(outerFolder, groundTruthFile, newFolderName)


##
# Create masks from an encoded file
#
source("createMaskFromEncodedFile.R")
outerFolder <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_test_testing';
encodedFile <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/sub-dsbowl2018-1.csv';
newFolderName <- 'predicted'
createMaskFromEncodedFile(outerFolder, encodedFile, newFolderName)










