
#!/bin/bash

sigma=$1
boolNorm=$2
boolPCA=$3

func_name=clusterData
res=100um_5umPad

# Define required directories
data_dir=~/EpilepsyQuantHistology/proc

code_dir=~/projects/rrg-akhanf/hrejali/Projects/EpilepsyHistology/code

#Load Python 
module load python

fn_List=$data_dir/${res}_SubjList/count/subjList.mat
fn_table=$data_dir/Table.csv
outDir=$data_dir/ClusterResults


# check if directory does not exist!
if [ ! -e $outDir ]
then
	mkdir $outDir
fi


echo INPUT: $fn_List
echo SLIDE LIST: $fn_table
echo OUTPUT DIRECTORY: $data_dir

# Run Python Code
singularity exec $SINGULARITY_OPTS histo-0.1.simg python3 $code_dir/clusterData.py -i $fn_table -list $fn_List -o $outDir --sig $sigma --norm $boolNorm --pca $boolPCA
# python ./code/clusterData.py -i $fn_table -list $fn_List -o $outDir --sig $sigma --norm $boolNorm --pca $boolPCA
echo ......................................... DONE ..............................................
