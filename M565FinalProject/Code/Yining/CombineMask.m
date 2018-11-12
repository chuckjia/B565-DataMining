%combined given masks in one graph named 'combine.png'
folder='stage1_train';
d=dir(folder);
subf=d([d.isdir]);
for k=3:numel(subf)
   subfolder=subf(k).name;
  subf1=fullfile(folder,subfolder,'/masks');
  f=dir([subf1 '/*.png']);
  file=fullfile(subf1,f(1).name);
  tmp=imread(file);
  for ii=2:numel(f)
      file=fullfile(subf1,f(ii).name);
      tmp1=imread(file);
      tmp=bitor(tmp,tmp1);
  end
  subf1=fullfile(folder,subfolder,'/Combine.png');
  imwrite(tmp,subf1);
%   image(tmp)
end