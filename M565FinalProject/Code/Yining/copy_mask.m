%copy the image in the subfolder 'image' and paste them in 'image's parent
%folder
stage1_test = './stage1_test';
subdirs = dir(stage1_test);

vLen = length(subdirs);

for ix1=1:vLen
    subdir = [stage1_test,'/',subdirs(ix1).name];
    if exist(subdir,'dir')~=7
        continue
    end
    subdir_image = [subdir,'/images'];
    images = dir(subdir_image);
    
    for ix2=1:length(images)
        iname = [subdir_image,'/',images(ix2).name];
        if exist(iname,'file')~=2
            continue;
        end
        suffix = images(ix2).name(end-3:end);
        if strcmp('.png',suffix)==1            
            copyfile(iname,subdir);
         end
    end
    
end


