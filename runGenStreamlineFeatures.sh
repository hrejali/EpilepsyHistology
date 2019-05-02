
#!/bin/bash

func_name=genStreamlineFeatures
res=100um_5umPad

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc
list_dir=~/EpilepsyQuantHistology/graham-histproc/subjects

searchpath=./code

#Load Matlab 
module load matlab

# Print inputs

echo INPUT: $data_dir
echo OUTPUT DIRECTORY: $list_dir
outDir=$data_dir/${res}_SubjList
echo OUTPUT DIRECTORY: $outDir

# check if directory does not exist!
if [ ! -e $outDir ]
then
	mkdir $outDir
fi

# Run Matlab 
echo "addpath(genpath('$searchpath'));  $func_name('$data_dir','$list_dir','$data_dir'); exit" | matlab -nosplash -nodesktop
echo ......................................... DONE ..............................................

