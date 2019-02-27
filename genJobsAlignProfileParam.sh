#!/bin/bash

joblist=alignjobs.txt

for sigma in 5 30 40 50
do
    for slack in 10 20 30 40 50 
	    do
		    for segmentLength in 25 50 75 100 
		    do
			    echo "./runAlignProfileParam.sh $sigma $slack $segmentLength" >> $joblist

		    done
	    done
    done

