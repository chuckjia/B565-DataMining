function r=Predict(Model,origin,sampleMask)
    height=Model.height;
    width=Model.width;
    CutMask=CutatCenter(sampleMask,height,width,origin);
    tsize=all(size(CutMask)==[height*2+1 width*2+1 3]);
    if(tsize==0)
     disp('Size error!');  
     return;
    end
    unroll=zeros((2*height+1)*(2*width+1)*3,1);
    for c=1:3
        for x=1:(2*height+1)
            for y=1:(2*width+1)
                unroll((c-1)*(2*height+1)*(2*width+1)+(x-1)*(2*width+1)+y,1)=CutMask(x,y,c);
            end
        end
    end
    f=(unroll/Model.SVMModel.KernelParameters.Scale)'*Model.SVMModel.Beta+Model.SVMModel.Bias;
    r=f>0.5;
end