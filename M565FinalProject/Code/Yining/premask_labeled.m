%generate candidate masks using training set and labeled them by true masks
%and false masks based on the given groundtruth masks
stage1_train = './stage1_train';
subdirs = dir(stage1_train);

vLen = length(subdirs);
N=zeros(vLen,3);

for ix1 = 1:vLen
    subdir = [stage1_train,'/',subdirs(ix1).name];
    if exist(subdir,'dir')~=7
        continue
    end
    image_path = [subdir,'/',subdirs(ix1).name,'.png'];
    if exist(image_path,'file')~=2
        continue
    end
    mask_path = [subdir,'/','combine.png'];
    if exist(mask_path,'file')~=2
       continue
    end
  
    tpred_img_dir = [subdir,'/trueprediction_images'];
    if exist(tpred_img_dir,'dir')~=7
        mkdir(tpred_img_dir);
    end
    
    fpred_img_dir = [subdir,'/falseprediction_images'];
    if exist(fpred_img_dir,'dir')~=7
        mkdir(fpred_img_dir);
    end
    
    I=imread(image_path); 
    truemask=imread(mask_path);
    I=rgb2gray(I); 
    %[peak ,loc]=max(imhist(I));
    %if(loc >= 127)
        % I=imcomplement(I);
   % end
    %if (loc<127)
        %I(I<=(loc+1))=0;
   % else
       % I(I>loc)=255;
       % I=imcomplement(I);
    %end
    level=graythresh(I);
    f1=im2bw(I,level);
    [peak0, loc0]=max(imhist(f1)); %segemation using threshold method
    if (loc0==2)
        f1=imcomplement(f1);
    end
    fullImageFile1 = fullfile(subdir,'threshold.png');
    imwrite(f1,fullImageFile1);
    CC0=bwconncomp(f1); %get the connected components CC0 of threshold method
    num0=CC0.NumObjects;
     
    [peak ,loc]=max(imhist(I)); %find the typical intensity of the background, and set them to be 0
    
    if (loc<127)
        I(I<=(loc+1))=0;
    else
        I(I>loc)=255;          %if the background is brighter than the object, take the complement of the graph
        I=imcomplement(I);
    end
   
    %'marker controled watershed'
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(I), hy, 'replicate');
    Ix = imfilter(double(I), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);
    se = strel('disk', 5);
    Io = imopen(I, se);
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Ioc = imclose(Io, se);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    fgm = imregionalmax(Iobrcbr);
    I2 = I;
    I2(fgm) = 255;
    se2 = strel(ones(3,3));
    fgm2 = imclose(fgm, se2);
    fgm3 = imerode(fgm2, se2);
    fgm4 = bwareaopen(fgm3, 3);
    I3 = I;
    I3(fgm4) = 255;
    bw = im2bw(Iobrcbr);
    D = bwdist(bw);
    DL = watershed(D);
    bgm = DL == 0;
    gradmag2 = imimposemin(gradmag, bgm | fgm4);
    L = watershed(gradmag2);
    
    wr1=(L==0);
    I4 = I;
    I4(wr1)=255; %segmentation using 'marker controled watershed' method
    %I4(imdilate(L == 0, ones(1, 1))) = 255;

    fullImageFile2 = fullfile(subdir,'watershed_with_marker.png');
    imwrite(I4,fullImageFile2);
    BW1=(I4<255);
    CC1=bwconncomp(BW1); %get the connected component CC1 of the 'marker controled watershed' method
    
    num0=CC0.NumObjects; %number of objects using threshold mehtod
    num1=CC1.NumObjects; %number of objects using 'marker controled watershed' method
    N(ix1,:)=[num0; num1; num1-num0];
    [m,n]=size(I); folder=pwd; tcount=0;fcount=0; 
   
  if ((num1-num0 <9) && (num1-num0 > -10))||(num0 < 11) %if the num0 and num1 does not have much differences or num0 is very small, using threshold method

       for k=1:num0
       f3=zeros(m,n);
       f3(CC0.PixelIdxList{k})=255;
       fcomp=bwconncomp(f3);
        if (fcomp.NumObjects > 3) %delele components having too many holes
            continue
        end
        U3 = uint8(f3);
        sumtemp=bitand(truemask,U3);
        ratio=sum(sum(sumtemp==255))/sum((sum(f3==255))); 
        if  ratio> (0.6299)
           tcount=tcount+1; %if most pixels of a candidate mask belong to the true mask, count it as true mask
           tfilename = sprintf('%s_%d','truepredict',tcount);
           tbaseImageFileName = sprintf('%s.png', tfilename);
           tfullImageFileName = fullfile(tpred_img_dir, tbaseImageFileName);
           imwrite(U3,tfullImageFileName);
        else
           fcount=fcount+1; %otherwise, count it as false
           ffilename = sprintf('%s_%d','falsepredict',fcount);
           fbaseImageFileName = sprintf('%s.png', ffilename);
           ffullImageFileName = fullfile(fpred_img_dir, fbaseImageFileName);
           imwrite(U3,ffullImageFileName);
        end
        %U3 = uint8(f3);
        %count=count+1;
        %filename = sprintf('%s_%d','predict',count);
        %baseFileName = sprintf('%s.mat', filename);
        %fullMatFileName = fullfile(folder,'predictions', baseFileName);
        %save(fullMatFileName, 'f3' );
        %baseImageFileName = sprintf('%s.png', filename);
        %fullImageFileName = fullfile(pred_img_dir, baseImageFileName);
        %imwrite(U3,fullImageFileName);
      end
  elseif (num0-num1 >= 390) %if num0 is much lager than num1, namely, there are a lot of noises or other objects that are not nuclei, 
      %using 'marker controled watershed' method
         for  k=1:num1
          f3=zeros(m,n);
          f3(CC1.PixelIdxList{k})=255;
          fcomp1=bwconncomp(f3);
          if (fcomp1.NumObjects > 3) %delele components having too many holes
             continue
          end
          U3 = uint8(f3);
          sumtemp=bitand(truemask,U3);
          ratio=sum(sum(sumtemp==255))/sum((sum(f3==255)));
          if  (ratio>0.6299)
            tcount=tcount+1;
            tfilename = sprintf('%s_%d','truepredict',tcount);
            tbaseImageFileName = sprintf('%s.png', tfilename);
            tfullImageFileName = fullfile(tpred_img_dir, tbaseImageFileName);
            imwrite(U3,tfullImageFileName);
          else
            fcount=fcount+1;
            ffilename = sprintf('%s_%d','falsepredict',fcount);
            fbaseImageFileName = sprintf('%s.png', ffilename);
            ffullImageFileName = fullfile(fpred_img_dir, fbaseImageFileName);
            imwrite(U3,ffullImageFileName);
          end
         %U3 = uint8(f3);
         %count=count+1;
         %filename = sprintf('%s_%d','predict',count);
         %baseFileName = sprintf('%s.png', filename);
         %fullMatFileName = fullfile(pred_img_dir, baseImageFileName);
         %imwrite(U3,fullImageFileName);
        end
  else %otherwise using watershed method, this will result in oversegmentation, introduce a lot false masks and even divide a true mask into several sub-masks
         f=I;
         f=medfilt2(f);
         h=fspecial('sobel');%
         fd=double(f);
         g=sqrt(imfilter(fd,h,'replicate').^2+imfilter(fd,h','replicate').^2);%

         g2=imclose(imopen(g,ones(3,3)),ones(3,3));

         l2=watershed(g2);%
         wr2=(l2==0);
         f2=f;
         f2(wr2)=255;
       
         fullImageFile3 = fullfile(subdir,'watershed.png');
         imwrite(f2,fullImageFile3);
         BW=(f2<255);
         CC=bwconncomp(BW);
         numPixels = cellfun(@numel,CC.PixelIdxList);
         num=CC.NumObjects;
         q1=quantile(numPixels,0.05); q2=quantile(numPixels,0.98); %delete components that are too small(a few pixels) or too large (backgrounds)
        for k=1:num
         if (numPixels(k)<= q1)||(numPixels(k)>= q2);
          continue
         end
         f3=zeros(m,n);
         f3(CC.PixelIdxList{k})=255;
         U3 = uint8(f3);
         sumtemp=bitand(truemask,U3);
         ratio=sum(sum(sumtemp==255))/sum((sum(f3==255)));
          if  (ratio>0.6299)
            tcount=tcount+1;
            tfilename = sprintf('%s_%d','truepredict',tcount);
            tbaseImageFileName = sprintf('%s.png', tfilename);
            tfullImageFileName = fullfile(tpred_img_dir, tbaseImageFileName);
            imwrite(U3,tfullImageFileName);
          else
            fcount=fcount+1;
            ffilename = sprintf('%s_%d','falsepredict',fcount);
            fbaseImageFileName = sprintf('%s.png', ffilename);
            ffullImageFileName = fullfile(fpred_img_dir, fbaseImageFileName);
            imwrite(U3,ffullImageFileName);
          end
         %count=count+1;
         %filename = sprintf('%s_%d','predict',count);
         
         %baseImageFileName = sprintf('%s.png', filename);
         %fullImageFileName = fullfile(pred_img_dir, baseImageFileName);
         %imwrite(U3,fullImageFileName);
       end
  end
end
tbl=tabulate(N(:,end)); %use this tabulate table to decide for what what values of |num1-num0| we should consider num0 and num1 to be similar 