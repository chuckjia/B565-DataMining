function All=main()
height=15;
width=15;
kfold=90;
folder='stage1_train';
d=dir(folder);
subf=d([d.isdir]);
numel(subf)
N=numel(subf);
if(N<kfold)
    disp('data too small');
    return;
end
TrainSet.width=width;
TrainSet.height=height;
TrainSet.N=N-2;
TrainSet.Train=zeros(N,1)
for i=1:round(N/kfold)
    TrainSet.Train(i,1)=1;
end
TrainSet.Train=TrainSet.Train(randperm(N));
TrainSet.Total=numel(subf);
%disp(TrainSet.Train);
All=Train(TrainSet);
%All.Raw.IMG(i).trueset store the real-prequalified masks.
%All.Raw.IMG(i).falseset store the fake-prequalified masks.
TrainSet.Train=zeros(1,1);
test(All,TrainSet);
disp(All.Model.classLoss);% the accuracy of the SVM
end
%first call main to obtain the model(contained in "All"), then play with
%Predict/test