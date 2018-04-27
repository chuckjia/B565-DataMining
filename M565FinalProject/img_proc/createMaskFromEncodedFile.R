
# install.packages("png")
library("png")
# install.packages("rstudioapi")
library(rstudioapi)

createMaskFromEncodedFile <- function(outerFolder, encodedFile, newFolder) {
    dset <- read.csv(encodedFile)
    ndpt <- nrow(dset)
    
    prevFolder <- ''
    imgmat <- matrix(0, nrow = 1, ncol = 1)
    maskNo <- 1
    
    height = 0
    width = 0
    
    cat("Here")
    
    for (row in 1:ndpt) {
        if (row %% 100 == 0) 
            cat("Processing row no. ", row, " out of ", ndpt, " rows\n", sep = "")
        
        dpt <- dset[row,]
        currFolder <- as.character(dpt$ImageId)
        
        if (currFolder != prevFolder) {
            maskNo <- 1
            prevFolder <- currFolder
            
            imgFile <- list.files(file.path(outerFolder, currFolder, 'images'), full.names = T)
            img <- readPNG(imgFile)
            height = nrow(img)
            width = ncol(img)
        }
        
        imgmat <- matrix(0, nrow = height, ncol = width)
        
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








