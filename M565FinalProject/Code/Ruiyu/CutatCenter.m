function S=CutatCenter(img,height,width,origin)
 maxlc=length(img(1,:));
 maxlr=length(img(:,1));
 hp = sum(img, 1) > 0; % Or whatever.
 fc= find(hp, 1, 'first');
 lc = find(hp, 1, 'last');
 vp = sum(img, 2) > 0; % Or whatever.
 fr= find(vp, 1, 'first');
 lr = find(vp, 1, 'last');
 r=bitand(origin(:,:,1),img);
 g=bitand(origin(:,:,2),img);
 b=bitand(origin(:,:,3),img);
 cc=round((fc+lc)/2);
 cr=round((fr+lr)/2);
 S = zeros(2*height+1,2*width+1:3);
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
  S=zeros(2*height+1,2*width+1,3);
 S(tmpfr:tmplr,tmpfc:tmplc,1)=r(maskfr:masklr,maskfc:masklc);
 S(tmpfr:tmplr,tmpfc:tmplc,2)=g(maskfr:masklr,maskfc:masklc);
 S(tmpfr:tmplr,tmpfc:tmplc,3)=b(maskfr:masklr,maskfc:masklc);
end