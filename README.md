# VerilogNeuralNetworkTests

This project contains verilog code for neural network functions.  So far, code only does prediction.  
There is currently no training.  Weights and biases from a trained network are used for testing.  There are 
currently two versions with half and single floating point precision.  Originally, double precision was used.
The precision has been decreased twice to lower resource usage.  Prediction results remain very close to 
the software result with double precision.  Resource usage is still high.  Improvements will be needed to 
fit training in a reasonably priced part.

Example results

First value, Verilog half precision.  Second value, double results from software.  This was image 1 of the test set.
The image was a 2, and both systems selected 2 with 95% confidence.  Note that the differences become larger
with very small values.

0.003726959228516       
0.003315

0.001200675964355	      
0.001102

0.9541015625	          
0.954877

0.027633666992188	      
0.028539

0.000320434570313	      
3E-06

0.003726959228516	      
0.003091

0.009574890136719	      
0.008

0.000320434570313	      
1E-06

0.001162528991699	      
0.00107

0.000320434570313	      
1E-06

