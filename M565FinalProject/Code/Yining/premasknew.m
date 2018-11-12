%generate candidate masks on test set
%load test1.mat first
stage1_test = './stage1_test';
subdirs = dir(stage1_test);

vLen = length(subdirs);
N=zeros(vLen,2);

for ix1 = 1:vLen
    subdir = [stage1_test,'/',subdirs(ix1).name];
    if exist(subdir,'dir')~=7
        continue
    end
    image_path = [subdir,'/',subdirs(ix1).name,'.png'];
    if exist(image_path,'file')~=2
        continue
    end
    % mask_path = [subdir,'/','combine.png'];
    %if exist(mask_path,'file')~=2
    %  continue
    %end
    % pred_dir = [subdir,'/predictions'];
    %if exist(pred_dir,'dir')~=7
    %mkdir(pred_dir);
    % end
    
    pred_img_dir = [subdir,'/prediction_images'];
    if exist(pred_img_dir,'dir')~=7
        mkdir(pred_img_dir);
    end
    
    I=imread(image_path); %should be replaced by the corresponding picutre name
    I=rgb2gray(I);
    [m,n]=size(I); folder=pwd; count=0;
    IndexC = strcmp(img_id, subdirs(ix1).name);
    cluster=HSV_CLUSTER(IndexC); %load cluster
    
    if isempty(cluster)==1
        cluster=1;
    end
    
    
    if cluster==0
        I=imcomplement(I);
        I=imadjust(I);
        level=graythresh(I);
        I10=im2bw(I,level);
        I20 = bwareaopen(I10, 9);
        I20 = imfill(I20,'holes');
        D0=bwdist(~I20,'chessboard');
        B0=-D0;
        B0(~I20)=-Inf;
        W0=watershed(B0,8);
        WR0=(W0==0);I30=I;I30(WR0)=255;
        fullImageFile_0 = fullfile(subdir,'segementation.png');
        imwrite(I30,fullImageFile_0);
        BW_0=(I30<255);
        CC_0=bwconncomp(BW_0);
        num_0=CC_0.NumObjects;
        for k=1:num_0
            f3=zeros(m,n);
            f3(CC_0.PixelIdxList{k})=255;
            sum1=sum(sum(f3==255)); %white pixels
            sum2=m*n-sum1; %black pixels
            if sum1>sum2
                continue
            end
%             fcomp=bwconncomp(imcomplement(f3));
%             if (fcomp.NumObjects > 3)
%                 continue
%             end
            f3=imfill(f3,'holes');
            U3 = uint8(f3);
            count=count+1;
            filename = sprintf('%s_%d','predict',count);
            
            baseImageFileName = sprintf('%s.png', filename);
            fullImageFileName = fullfile(pred_img_dir, baseImageFileName);
            imwrite(U3,fullImageFileName);
        end
        
    elseif cluster==2
        I=imcomplement(I);
        I=imadjust(I);
        thresh=multithresh(I,3);
        I12=(I>thresh(3));
        I22 = bwareaopen(I12, 9);
        I22 = imfill(I22,'holes');
        D2=bwdist(~I22,'chessboard');
        B2=-D2;
        B2(~I22)=-Inf;
        W2=watershed(B2,8);
        WR2=(W2==0);I32=I;I32(WR2)=255;
        fullImageFile_2 = fullfile(subdir,'segementation.png');
        imwrite(I32,fullImageFile_2);
        BW_2=(I32<255);
        CC_2=bwconncomp(BW_2);
        num_2=CC_2.NumObjects;
        for k=1:num_2
            f3=zeros(m,n);
            f3(CC_2.PixelIdxList{k})=255;
            sum1=sum(sum(f3==255)); %white pixels
            sum2=m*n-sum1; %black pixels
            if sum1>sum2
                continue
            end
%             fcomp=bwconncomp(imcomplement(f3));
%             if (fcomp.NumObjects > 3)
%                 continue
%             end
            f3=imfill(f3,'holes');
            U3 = uint8(f3);
            count=count+1;
            filename = sprintf('%s_%d','predict',count);
            
            baseImageFileName = sprintf('%s.png', filename);
            fullImageFileName = fullfile(pred_img_dir, baseImageFileName);
            imwrite(U3,fullImageFileName);
        end
        
    else
        I=medfilt2(I);
        level=graythresh(I);
        f1=im2bw(I,level);
        [peak0, loc0]=max(imhist(f1));
        if (loc0==2)
            f1=imcomplement(f1);
        end
        cc1=bwconncomp(f1);
        n1=cc1.NumObjects;
        fullImageFile1 = fullfile(subdir,'threshold_ostu.png');
        imwrite(f1,fullImageFile1);
        
        
        h=imhist(I);
        
        level_2=triangle_th(h,256);
        f2=im2bw(I,level_2);
        %[peak2, loc2]=max(imhist(f2));
        if (loc0==2)
            f2=imcomplement(f2);
        end
        fullImageFile2 = fullfile(subdir,'threshold_triangle.png');
        imwrite(f2,fullImageFile2);
        cc2=bwconncomp(f2);
        n2=cc2.NumObjects;
        
        
        
        %[peak ,loc]=max(h);
        
        %if (loc>=127)
        %I=imcomplement(I);
        %end
        
        %
        %        hy = fspecial('sobel');
        %        hx = hy';
        %        Iy = imfilter(double(I), hy, 'replicate');
        %        Ix = imfilter(double(I), hx, 'replicate');
        %        gradmag = sqrt(Ix.^2 + Iy.^2);
        %        se = strel('disk', 5);
        %        Io = imopen(I, se);
        %        Ie = imerode(I, se);
        %        Iobr = imreconstruct(Ie, I);
        %        Ioc = imclose(Io, se);
        %        Iobrd = imdilate(Iobr, se);
        %        Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
        %        Iobrcbr = imcomplement(Iobrcbr);
        %        fgm = imregionalmax(Iobrcbr);
        %        I2 = I;
        %        I2(fgm) = 255;
        %        se2 = strel(ones(3,3));
        %        fgm2 = imclose(fgm, se2);
        %        fgm3 = imerode(fgm2, se2);
        %        fgm4 = bwareaopen(fgm3, 3);
        %        I3 = I;
        %        I3(fgm4) = 255;
        %        bw = im2bw(Iobrcbr);
        %        D = bwdist(bw);
        %        DL = watershed(D);
        %        bgm = DL == 0;
        %        gradmag2 = imimposemin(gradmag, bgm | fgm4);
        %        L = watershed(gradmag2);
        %
        %        wr1=(L==0);
        %        I4 = I;
        %        I4(wr1)=255;
        
        
        % fullImageFile2 = fullfile(subdir,'watershed_with_marker.png');
        % imwrite(I4,fullImageFile2);
        %BW1=(I4<255);
        %CC1=bwconncomp(BW1);
        
        %num0=CC0.NumObjects;
        %num1=CC1.NumObjects;
        N(ix1,:)=[n1,n2];
        
        if (n1>=n2)||(n2-n1>60)
            D1=bwdist(~f1,'chessboard');
            B1=-D1;
            B1(~f1)=-Inf;
            W1=watershed(B1,8);
            WR1=(W1==0);I31=I;I31(WR1)=255;
            BW_1=(I31<255);
            fullImageFile_1 = fullfile(subdir,'segementation.png');
            imwrite(I31,fullImageFile_1);
            CC0=bwconncomp(BW_1);
            num0=CC0.NumObjects;
            
            for k=1:num0
                f3=zeros(m,n);
                f3(CC0.PixelIdxList{k})=255;
                sum1=sum(sum(f3==255)); %white pixels
                sum2=m*n-sum1; %black pixels
                if sum1>sum2
                    continue
                end
                %         fcomp=bwconncomp(imcomplement(f3));
                %         if (fcomp.NumObjects > 3)
                %             continue
                %         end
                f3=imfill(f3,'holes');
                U3 = uint8(f3);
                count=count+1;
                filename = sprintf('%s_%d','predict',count);
                %baseFileName = sprintf('%s.mat', filename);
                %fullMatFileName = fullfile(folder,'predictions', baseFileName);
                %save(fullMatFileName, 'f3' );
                baseImageFileName = sprintf('%s.png', filename);
                fullImageFileName = fullfile(pred_img_dir, baseImageFileName);
                imwrite(U3,fullImageFileName);
            end
            
        else
            
            D12=bwdist(~f2);
            B12=-D12;
            B12(~f2)=-Inf;
            W12=watershed(B12,8);
            WR12=(W12==0);I12=I;I12(WR12)=255;
            fullImageFile_12 = fullfile(subdir,'segementation.png');
            imwrite(I12,fullImageFile_12);
            BW_12=(I12<255);
            CC1=bwconncomp(BW_12);
            numPixels = cellfun(@numel,CC1.PixelIdxList);
            q1=quantile(numPixels,0.03); %q2=quantile(numPixels,0.98);
            num1=CC1.NumObjects;
            for k=1:num1
                if (numPixels(k)<= q1)%||(numPixels(k)>= q2);
                    continue
                end
                f3=zeros(m,n);
                f3(CC1.PixelIdxList{k})=255;
                sum1=sum(sum(f3==255)); %white pixels
                sum2=m*n-sum1; %black pixels
                if sum1>sum2
                    continue
                end
                %               fcomp=bwconncomp(imcomplement(f3));
                %               if (fcomp.NumObjects > 3)
                %                   continue
                %               end
                %f3=imfill(f3,'holes');
                U3 = uint8(f3);
                count=count+1;
                filename = sprintf('%s_%d','predict',count);
                
                baseImageFileName = sprintf('%s.png', filename);
                fullImageFileName = fullfile(pred_img_dir, baseImageFileName);
                imwrite(U3,fullImageFileName);
            end
        end
    end
end
%tbl=tabulate(N(:,end)); %use this tabulate table to decide for what what values of |num1-num0| we should consider num0 and num1 to be similar
%fileID = fopen('NumObjects.txt','w');
%fprintf(fileID,'%d %d %d\n', N(3:end,:));
%fclose(fileID);



