
#!/bin/bash

sigma=$1
slack=$2
segmentLength=$3

func_name=appAlignProfile
res=100um_5umPad

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc

searchpath=./code

#Load Matlab 
module load matlab

in_dir=$data_dir/${res}_SubjList
echo INPUT: $in_dir
echo OUTPUT DIRECTORY: $data_dir

# Run Matlab 
echo "addpath(genpath('$searchpath'));  $func_name('$in_dir','$data_dir',[$sigma,$segmentLength,$slack]); exit" | matlab -nosplash -nodesktop
echo ......................................... DONE ..............................................
