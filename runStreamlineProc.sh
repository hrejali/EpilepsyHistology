#!/bin/bash


if [ "$#" -lt 1 ]
then
	echo "Usage: $0 <subjids>"
	exit 0
fi

func_name=StreamLineComp
res=100um

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc
searchpath=./code

#Load Matlab 
module load matlab

for subj in $@
do
	subj_dir=$data_dir/${subj}
	seglist=$(ls -d $subj_dir/${res}_Segmentations/EPI*)

	# run through each segmentation for a particular subject
	for slide in $seglist
	do
		echo SEGMENTATION INPUT: $slide
		outDir=$subj_dir/${res}_StreamLines
		echo OUTPUT DIRECTORY: $outDir

		# check if directory does not exist!
		if [ ! -e $outDir ]
		then
			mkdir $outDir
		fi

		# Run Matlab 
		echo "addpath(genpath('$searchpath'));  $func_name('$slide','$outDir'); exit" | matlab -nosplash -nodesktop
		echo ......................................... DONE ..............................................

	done
done



