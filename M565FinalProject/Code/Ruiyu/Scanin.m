function S=Scanin(N)
folder='stage1_train';
%folder='stage1_test_v1';
d=dir(folder);
subf=d([d.isdir]);
S.nt=0;
S.nf=0;
for k=3:N
   fprintf("Scan k=%d\n",k);
  subfolder=subf(k).name;
  originpath=fullfile(folder,subfolder,strcat(subfolder,'.png'));
  S.IMG(k-2).origin=imread(originpath);
  S.IMG(k-2).trueset=[];
  S.IMG(k-2).falseset=[];
  S.IMG(k-2).nt=0;
  S.IMG(k-2).nf=0;
  subf_true=fullfile(folder,subfolder,'/trueprediction_images');
  ft=dir([subf_true '/*.png']);
  for ii=1:numel(ft)
      tmp=subf_true;
      file=fullfile(tmp,ft(ii).name);
      tmp1=imread(file);
      S.IMG(k-2).trueset{end+1}=tmp1;
      S.IMG(k-2).nt= S.IMG(k-2).nt+1;
      S.nt=S.nt+1;
  end
  subf_false=fullfile(folder,subfolder,'/falseprediction_images');
  ft=dir([subf_false '/*.png']);
  for ii=1:numel(ft)
      tmp=subf_false;
      file=fullfile(tmp,ft(ii).name);
      tmp1=imread(file);
      S.IMG(k-2).falseset{end+1}=tmp1;
      S.IMG(k-2).nf= S.IMG(k-2).nf+1;
      S.nf=S.nf+1;
  end
  S.N=N-2;
end