function result = calcIOU_batch(predFolder, trueFolder)
%CALCIOU_BATCH Calculate the IOU values for all the predictions in a folder
%   Input:: predFolder: path to folder containing predicted binary masks 
%           trueFolder: path to folder containing true binary masks
%   Output:: result: a vector containing IOU value for each true mask with its best match. 
%                    Non-matches are labeled-1

imagesPred = imageDatastore(predFolder);
imagesTrue = imageDatastore(trueFolder);

ntrue = length(imagesTrue.Files);
npred = length(imagesPred.Files);
result = repmat(-1, ntrue, 1);

% For each predicted mask, find its best match among the true masks
for imgNo = 1:npred
    predMask = readimage(imagesPred, imgNo);
    
    maxMaskNo = 1;
    maxIOU = calcIOU(readimage(imagesTrue, 1), predMask);
    
    for maskNo = 2:ntrue
        currIOU = calcIOU(readimage(imagesTrue, maskNo), predMask);
        if currIOU > maxIOU
            maxIOU = currIOU;
            maxMaskNo = maskNo;
        end
    end
    
    if (maxIOU >= result(maxMaskNo))
        result(maxMaskNo) = maxIOU;
    end
end

end

