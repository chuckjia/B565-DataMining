rm(list = ls())
cat("\014")

# install.packages("png")
library("png")

outerFolder <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_test';
groundTrueFile <- '/Users/chuckjia/Documents/Workspace/DataStorage/B565/stage1_solution.csv';

createTrueTestMask <- function(outerFolder, groundTrueFile) {
    dset <- read.csv(inputFile)
    ndpt <- nrow(dset)
    
    prevFolder <- ''
    imgmat <- matrix(0, nrow = 1, ncol = 1)
    maskNo <- 1
    
    for (row in 1:ndpt) {
        cat("Processing row no. ", row, " out of ", ndpt, " rows\n", sep = "")
        
        dpt <- dset[row,]
        currFolder <- as.character(dpt$ImageId)
        
        height = dpt$Height
        width = dpt$Width
        
        imgmat <- matrix(0, nrow = height, ncol = width)
        
        if (currFolder != prevFolder) {
            maskNo <- 1
            prevFolder <- currFolder
        }
        
        pixels <- scan(text = as.character(dpt$EncodedPixels), what = 0L, sep = " ", quiet = T)
        num_cells <- length(pixels) / 2
        
        for (i in 1:num_cells) {
            pixNo = pixels[2 * i - 1]
            len = pixels[2 * i]
            
            for (j in 1:len) {
                index_col <- ceiling(pixNo / height)
                index_row <- pixNo - (index_col - 1) * height
                
                imgmat[index_row, index_col] <- 1
                pixNo = pixNo + 1
            }
        }
        
        folderToWrite <- file.path(outerFolder, currFolder, "masks")
        dir.create(folderToWrite)
        outputfilename <- file.path(folderToWrite, paste(maskNo, ".png", sep = ""))
        writePNG(imgmat, outputfilename)
        maskNo = maskNo + 1
    }
}








