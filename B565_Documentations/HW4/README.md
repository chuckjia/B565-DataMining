# B565 Homework 4 Code

This documentation is for the code in the submitted solutions to the 3rd assignment of B565 (with the title "Homework 4", as "Homework 3" is the final project proposal).

## Problem 2

  The main code of the part is written in MATLAB.

  - To run the apriori algorithm using confidence levels, run the `apriori()` function.
    The apriori function contains code that generates frequent itemsets and rules.

  - To use the lift levels as interestingness measure, run the `apriori_lift()` function.

  - The script `examples.m` provides examples on using the two functions.

  - The data sets are contained in the folder `data`. The raw data and data source links
    are in the file `UCI Hyperlink.txt`

  - Preprocessing code of the raw datasets, written in R, is in `data/Preproc.R`.



## Problem 3

  The main code of the part is written in C++.

  - To run the program, compile and run p3.cpp. The execution of p3 uses the following
    format
        p3 [Method] [DistFcn] [IfUseUserDemo] [DataSet] [TrainFile] [TestFile]
           [UserDemoFile] [Min#Neighbors] [Max#Neighbors]
    where
      - `[Method]` = naive, nnb
      - `[DistFcn]` = euclidean, mink1, mink2, mink3, mink7, minkInf, cosine
      - `[IfUseUserDemo]` = use, no_use
      - `[DataSet]` = 100k, 10m
    Examples are given in Makefile.

  - `data/100k/user_info.csv` is used for the user information. It is derived from the
    `u.user` file. The processing code is written in the R file: `Prelim.R`.
