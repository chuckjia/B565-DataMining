1. Problem 2 code:

This part is coded in C++. Note C++ 2011 standard is assumed.

To run this program on Linux or MacOS, enter in the terminal: 
    $ make uniform
    $ make normal
for experiments with uniform and normal random number generator. The makefile commands will be executed and the C++ program will be compiled and run. The final results are in the .csv files.


2. Problem 3 code:

This part is coded in MATLAB. 

Standard k-means and Elkan's k-means are written as MATLAB functions with 3 inputs. Run in the terminal with command
    $ matlab -r 'kmeans('filename', num_cluster, dist_fcn)'
    $ matlab -r 'kmeans_elkan('filename', num_cluster, dist_fcn)'

To run the evaluation function, use 
    $ matlab -r 'evaluation('filename', num_cluster, method_no, dist_fcn)'

See detailed description in the pdf file.