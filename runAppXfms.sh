
#!/bin/bash

if [ "$#" -lt 1 ]
then
	echo "Usage: $0 < -f FEATURE >  <subjids>"
	exit 0
fi



while getopts "f:" options; do
 case $options in
    f ) echo "	Using feature: $OPTARG" 
	Feature=$OPTARG;;
    * ) usage
	exit 1;;
 esac
done


shift 1

func_name=appXfms
res=100um_5umPad

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc
searchpath=./code

#Load Matlab 
module load matlab

for subj in $@
do
	subj_dir=$data_dir/${subj}
	list=$(ls -d $subj_dir/${res}_Profiles/count/EPI*)

	# run through each subject
	for slide in $list
	do
		echo INPUT: $slide
		outDir=$subj_dir/${res}_Profiles/$Feature
		echo OUTPUT DIRECTORY: $outDir

		# check if directory does not exist!
		if [ ! -e $outDir ]
		then
			mkdir $outDir
		fi

		# Run Matlab 
		echo "addpath(genpath('$searchpath'));  $func_name('$slide','$Feature'); exit" | matlab -nosplash -nodesktop
		echo ......................................... DONE ..............................................

	done
done