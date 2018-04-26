function iou = calcIOU(mask1, mask2)
%CALCIOU Calculate IOU between two binary masks

intersectionArea = nnz(mask1 & mask2);
unionArea = nnz(mask1 | mask2);
iou = intersectionArea / unionArea;

end

