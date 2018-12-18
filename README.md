# EpilepsyHistology

## StreamLine Computation--StreamLineComp.m (MATLAB)
This code was developed to create a tool for sampling the laminae of the cortex in histology. Must clone the following git repository: https://github.com/jordandekraker/HippUnfolding. Add path to all 
subfolders. The repositroy contains laplace solver and few other tools used in the script

To run the call the function **StreamLineComp(SegmentedImageDir,OutputDir)**.
Assumes that you've inputed a segmented nifti image and that its in the directory you've specified. Segmented image
contains 3 componets GM == 1, WM == 2, Background ==3, addtionally an ignore label ignore==4 which is regions to 
ignore. The ignore label is required and must be placed at the end of the tissue - an example is shown in the image below. 

The function takes in two parameters:
  1) Input directory (Mandatory)
  2) Output directory (Default is current directory)  
  
  Result Overlaped ontop of Neuron Density Feature Map is shown below:
  

Read [Coordinate System for the Cortical Laminae](https://github.com/hrejali/EpilepsyHistology/blob/master/AIP_PROJECT.pdf) for more information about motivations and methods for the StreamLineComp script. 
