
# install.packages("png")
library("png")
# install.packages("rstudioapi")
library(rstudioapi)

# Input:: outerFolder: outmost folder for the test data
#         groundTruthFile: the CSV file that encodes the final mask results
#         newFolder: the name of the new subfolder you want to contain the ground truth masks

createMaskFromGroundTruth <- function(outerFolder, groundTruthFile, newFolder) {
    dset <- read.csv(groundTruthFile)
    ndpt <- nrow(dset)
    
    prevFolder <- ''
    imgmat <- matrix(0, nrow = 1, ncol = 1)
    maskNo <- 1
    
    for (row in 1:ndpt) {
        if (row %% 100 == 0) 
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
        
        folderToWrite <- file.path(outerFolder, currFolder, newFolder)
        dir.create(folderToWrite)
        outputfilename <- file.path(folderToWrite, paste(maskNo, ".png", sep = ""))
        writePNG(imgmat, outputfilename)
        maskNo = maskNo + 1
    }
}








