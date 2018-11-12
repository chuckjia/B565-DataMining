function All=Train(TrainSet)
N=TrainSet.N;
All.Raw=Scanin(TrainSet.N+2);
All.Processed=Preprocess(TrainSet.height,TrainSet.width,All.Raw,TrainSet.Train);
All.Model=SVM(All.Processed);
end