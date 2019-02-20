#!/bin/bash

joblist=alignjobs.txt

for sigma in 10 15 20 25 30 50
do
    for slack in 5 10 20 40 50 
	    do
		    for segmentLength in 25 50 75 100 200 
		    do
			    echo "runAlignProfileParam.sh $sigma $slack $segmentLength" >> $joblist

		    done
	    done
    done

