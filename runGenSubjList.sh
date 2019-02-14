
#!/bin/bash


if [ "$#" -lt 1 ]
then
	echo "Usage: $0 <subjids>"
	exit 0
fi

func_name=genSubjList
res=100um_5umPad

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc
searchpath=./code

#Load Matlab 
module load matlab

for subj in $@
do
	subj_dir=$data_dir/${subj}
	list=$(ls -d $subj_dir/${res}_Profiles/EPI*)

	# run through each subject
	for slide in $list
	do
		echo INPUT: $slide
		outDir=$data_dir/${res}_SubjList
		echo OUTPUT DIRECTORY: $outDir

		# Run Matlab 
		echo "addpath(genpath('$searchpath'));  $func_name('$slide','$outDir'); exit" | matlab -nosplash -nodesktop
		echo ......................................... DONE ..............................................

	done