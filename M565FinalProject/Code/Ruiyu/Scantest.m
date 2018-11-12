folder='stage1_test';
d=dir(folder);
subf=d([d.isdir]);
N=numel(subf);
for k=3:N
   fprintf("Scan k=%d\n",k);
  subfolder=subf(k).name;
  originpath=fullfile(folder,subfolder,strcat(subfolder,'.png'));
  PredictionPath=fullfile(folder,subfolder,'FinalPredict/');
  mkdir (PredictionPath);
  subf_mask=fullfile(folder,subfolder,'/prediction_images');
  masks=dir([subf_mask '/*.png']);
  origin=imread(originpath);
  for ii=1:numel(masks)
      tmp=subf_mask;
      file=fullfile(tmp,masks(ii).name);
      target=fullfile(PredictionPath,masks(ii).name);
      tmp1=imread(file);
      if Predict(Model,origin,tmp1)>0
      imwrite(tmp1,target);
      fprintf("%d yes %d\n",k,ii);
      else
          fprintf("%d no %d\n",k,ii);
      end
  end
  %S.IMG(k-2).origin=imread(originpath);
end