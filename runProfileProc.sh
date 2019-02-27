
#!/bin/bash


if [ "$#" -lt 1 ]
then
	echo "Usage: $0 <subjids>"
	exit 0
fi

func_name=appProfileProc
res=100um
resOut=100um_5umPad

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc
searchpath=./code

#Load Matlab 
module load matlab

for subj in $@
do
	subj_dir=$data_dir/${subj}
	list=$(ls -d $subj_dir/${res}_StreamLines/EPI*)

	# run through each subject
	for slide in $list
	do
		echo INPUT: $slide
		outDir=$subj_dir/${resOut}_Profiles
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
