function NULL=test(All,TrainSet)
t=false;
if size(TrainSet.Train,1)~=TrainSet.N
    t=true;
end
tt=0;
tf=0;
ft=0;
ff=0;
for i=1:TrainSet.N
    t0=false;
    if t
       t0=true;
    else
        t0=TrainSet.Train(i);
    end
    if All.Raw.IMG(i).nf>200
        t0=false;
    end
    if t0
    fprintf("i=%d %d %d\n",i,All.Raw.IMG(i).nt,All.Raw.IMG(i).nf);
    %Predict(All.Model,All.Raw.IMG(i).origin,All.Raw.IMG(i).trueset{j})
    %Predict(All.Model,All.Raw.IMG(i).origin,All.Raw.IMG(i).falseset{j})
    % will indicate whether the corresponding pre-qualified
    % mask(All.Raw.IMG(i).trueset{j}/All.Raw.IMG(i).falseset{j}) is
    % recoginized as a "correct" mask. To verify the result, compare with
    % what is in the mask folder(not included in "All") following the
    % evaluation strategy.
    for j=1:All.Raw.IMG(i).nt
        pred=Predict(All.Model,All.Raw.IMG(i).origin,All.Raw.IMG(i).trueset{j});
        if(pred>0.5) tt=tt+1;
        else
            ff=ff+1;
        end
    %   fprintf("i=%d j=%d T pref=%d\n",i,j,Predict(All.Model,All.Raw.IMG(i).origin,All.Raw.IMG(i).trueset{j}));
    end
    for j=1:All.Raw.IMG(i).nf
                pred=Predict(All.Model,All.Raw.IMG(i).origin,All.Raw.IMG(i).falseset{j});
        if(pred<0.5) tf=tf+1;
        else
            ft=ft+1;
        end
      % fprintf("i=%d j=%d F pref=%d\n",i,j,Predict(All.Model,All.Raw.IMG(i).origin,All.Raw.IMG(i).falseset{j}));
    end
    end
end
fprintf("tt=%d tf=%d ft=%d ff=%d\n",tt,tf,ft,ff);
end