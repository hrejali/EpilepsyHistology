# EpilepsyHistology

## Profile Computation--ProfileComp.m (MATLAB)
Must clone the following git repository: https://github.com/jordandekraker/HippUnfolding. Add path to all 
subfolders. The repositroy contains laplace solver and few other tools used in the script

To run the call the function **ProfileComp(SegmentedImageDir,OutputDir)**.
Assumes that you've inputed a segmented nifti image and that its in the directory you've specified. Segmented image
contains 3 componets GM == 1, WM == 2, Background ==3, addtionally can have third label ignore==4 which is regions to 
ignore.The function takes in two parameters:
  1) Input directory (Mandatory)
  2) Output directory (Default is current directory)  

Read [Coordinate System for the Cortical Laminae](../AIP.pdf) file for more information about motivations and methods for the ProfileComp script. 
