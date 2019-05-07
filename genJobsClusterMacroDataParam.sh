#!/bin/bash

joblist=clusterDatajobs.txt

for sigma in 1 5 10 15 20 30
do

	echo "./runClusterMacroDataParam.sh $sigma" >> $joblist

done

