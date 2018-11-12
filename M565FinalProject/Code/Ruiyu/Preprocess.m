function S=Preprocess(height,width,RawData,Train)
S.width=width;
S.height=height;
S.trueset=[];
S.falseset=[];
N=RawData.N;
t=(N+2~=size(Train,1));
tt=0;
for k=1:N
  fprintf("Preprocess k=%d\n",k);
  if t
      t0=true;
  else
      t0=Train(k);
  end
  if RawData.IMG(k).nf>200
        t0=false;
  end
  if t0
      tt=tt+1
  origin=RawData.IMG(k).origin;
  originred=origin(:,:,1);
  origingreen=origin(:,:,2);
  originblue=origin(:,:,3);
 maxlc=length(origin(1,:,1));
 maxlr=length(origin(:,1,1));
 
 
  for ii=1:RawData.IMG(k).nt
        tmp1=RawData.IMG(k).trueset{ii};
        tmpr=tmp1;
        hp = sum(tmpr, 1) > 0; % Or whatever.
        fc= find(hp, 1, 'first');
        lc = find(hp, 1, 'last');
        vp = sum(tmpr, 2) > 0; % Or whatever.
        fr= find(vp, 1, 'first');
        lr = find(vp, 1, 'last');
        cc=round((fc+lc)/2);
        cr=round((fr+lr)/2);
        
        tmpfr=1;
        tmplr=2*height+1;
        tmpfc=1;
        tmplc=2*width+1; 
        maskfr=cr-height;
        masklr=cr+height;
        maskfc=cc-width;
        masklc=cc+width;
        if(maskfr<1)
            tmpfr=tmpfr+1-maskfr;
            maskfr=1;
        end
        if(maskfc<1)
            tmpfc=tmpfc+1-maskfc;            
            maskfc=1;
        end
        if(masklr>maxlr)
            tmplr=tmplr-(masklr-maxlr);
            masklr=maxlr;
        end
        
        if(masklc>maxlc)
            tmpfc=tmpfc+(masklc-maxlc);
            masklc=maxlc;
        end
        
      tmpp = zeros(2*height+1,2*width+1:3);
      % fprintf("\ni=%d\n",ii);
      %  disp(size(tmp1));
     % fprintf("%d True Image %3d %3d %3d %3d %2d %2d\n",ii,fc,lc,fr,lr,(lc-fc),(lr-fr));
     %  fprintf("%d %d %d %d\n",maskfr,masklr,maskfc,masklc);
   % image(tmp1);  
     % image(tmp1(240:256,230:240));
     % image(tmp1(maskfr:masklr,maskfc:masklc));
      
    %%{  
    tmpr=bitand(originred(maskfr:masklr,maskfc:masklc),tmp1(maskfr:masklr,maskfc:masklc));
      tmpg=bitand(origingreen(maskfr:masklr,maskfc:masklc),tmp1(maskfr:masklr,maskfc:masklc));
      tmpb=bitand(originblue(maskfr:masklr,maskfc:masklc),tmp1(maskfr:masklr,maskfc:masklc));
      tmpp(tmpfr:tmplr,tmpfc:tmplc,1)=tmpr;
      tmpp(tmpfr:tmplr,tmpfc:tmplc,2)=tmpg;
      tmpp(tmpfr:tmplr,tmpfc:tmplc,3)=tmpb;
      S.trueset{end+1}=tmpp;
%%}
      %{
     %   fprintf("%d True Image %3d %3d %3d %3d %2d %2d\n",ii,fr,lr,fc,lc,(lr-fr),(lc-fc));
        if(lr-fr>tmaxr)
            tmaxr=lr-fr;
            fprintf("T %d tmaxr update: %d %d %d\n",ii,tmaxr, lr,fr);
        end
        if(lc-fc>tmaxc)
            tmaxc=lc-fc;
            fprintf("T %d tmaxc update: %d %d %d\n",ii,tmaxc, lc,fc);
        end
%}
  end
  for ii=1:RawData.IMG(k).nf
    tmp1=RawData.IMG(k).falseset{ii};
        tmpr=tmp1;
        hp = sum(tmpr, 1) > 0; % Or whatever.
        fc= find(hp, 1, 'first');
        lc = find(hp, 1, 'last');
        vp = sum(tmpr, 2) > 0; % Or whatever.
        fr= find(vp, 1, 'first');
        lr = find(vp, 1, 'last');
        cc=round((fc+lc)/2);
        cr=round((fr+lr)/2);
        
        tmpfr=1;
        tmplr=2*height+1;
        tmpfc=1;
        tmplc=2*width+1; 
        maskfr=cr-height;
        masklr=cr+height;
        maskfc=cc-width;
        masklc=cc+width;
        
        if(maskfr<1)
            tmpfr=tmpfr+1-maskfr;
            maskfr=1;
        end
        if(maskfc<1)
            tmpfc=tmpfc+1-maskfc;            
            maskfc=1;
        end
        if(masklr>maxlr)
            tmpfr=tmpfr+(masklr-maxlr);
            masklr=maxlr;
        end
        
        if(masklc>maxlc)
            tmpfc=tmpfc+(masklc-maxlc);
            masklc=maxlc;
        end
      %  fprintf("%d %d %d %d\n",maskfr,masklr,maskfc,masklc);
      %  fprintf("%d %d %d %d\n",tmpfr,tmplr,tmpfc,tmplc);
      tmpp = zeros(2*height+1,2*width+1:3);
      % fprintf("\ni=%d\n",ii);
      %  disp(size(tmp1));
     % fprintf("%d True Image %3d %3d %3d %3d %2d %2d\n",ii,fc,lc,fr,lr,(lc-fc),(lr-fr));
     %  fprintf("%d %d %d %d\n",maskfr,masklr,maskfc,masklc);
   % image(tmp1);  
     % image(tmp1(240:256,230:240));
     % image(tmp1(maskfr:masklr,maskfc:masklc));
      
    %%{  
    tmpr=bitand(originred(maskfr:masklr,maskfc:masklc),tmp1(maskfr:masklr,maskfc:masklc));
      tmpg=bitand(origingreen(maskfr:masklr,maskfc:masklc),tmp1(maskfr:masklr,maskfc:masklc));
      tmpb=bitand(originblue(maskfr:masklr,maskfc:masklc),tmp1(maskfr:masklr,maskfc:masklc));
      tmpp(tmpfr:tmplr,tmpfc:tmplc,1)=tmpr;
      tmpp(tmpfr:tmplr,tmpfc:tmplc,2)=tmpg;
      tmpp(tmpfr:tmplr,tmpfc:tmplc,3)=tmpb;
   %   fprintf("k=%d i=%d\n",k,ii);
    %   disp(size(tmpp));
      S.falseset{end+1}=tmpp;
  end
  end
end
S.n1=size(S.trueset);
S.n2=size(S.falseset);
S.n=S.n1(2)+S.n2(2);
fprintf("n1:%d n2:%d n:%d\n\n",S.n1(2),S.n2(2),S.n);
end
