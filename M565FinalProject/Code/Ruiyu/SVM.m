
function result=SVM(Data)
height=Data.height;
width=Data.width;
result.height=height;
result.width=width;
allset=horzcat(Data.trueset,Data.falseset);
unroll=zeros((2*width+1)*(2*height+1)*3,Data.n);
for i = 1: Data.n1(2)
   for c=1:3
        for x=1:(2*height+1)
            for y=1:(2*width+1)
                unroll((c-1)*((2*height+1)*(2*width+1))+(x-1)*(2*width+1)+y,i)=Data.trueset{i}(x,y,c);
            end
        end
   end
end
for i = 1: Data.n2(2)
   for c=1:3
        for x=1:2*height+1
            for y=1:2*width+1
                unroll((c-1)*((2*height+1)*(2*width+1))+(x-1)*(2*width+1)+y,i+Data.n1(2))=Data.falseset{i}(x,y,c);
            end
        end
   end
end
a=ones(Data.n1);
b=zeros(Data.n2);
respond=horzcat(a,b);
disp(size(unroll));
%'gaussian'
%result.SVMModel=fitcsvm(transpose(unroll),transpose(respond),'KernelFunction','polynomial','PolynomialOrder',4,'HyperparameterOptimizationOptions',struct('UseParallel',true,'MaxTime',3600*12,'Verbose',2));
result.SVMModel=fitcsvm(transpose(unroll),transpose(respond),'HyperparameterOptimizationOptions',struct('UseParallel',true,'MaxTime',3600*12,'Verbose',2));
result.CVSVMModel = crossval(result.SVMModel);
result.classLoss = kfoldLoss(result.CVSVMModel);
%SVMModel=fitclinear(transpose(unroll),transpose(respond),'KFold',5);
%classLoss=kfoldLoss(SVMModel);
disp(result.classLoss);
end
