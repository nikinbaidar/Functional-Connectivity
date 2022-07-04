#!/bin/bash
. /etc/profile

segbatchPath=~/practice/Scripts_Preprocessing
path=$2
subjectID=$1
        echo $subjectID
	#to allocate seg.m and seg_job.m in the /home/rp/Data/script to every sample's folder.
        cp ${segbatchPath}/seg.m $path/$subjectID
        cp ${segbatchPath}/seg_job.m $path/$subjectID
	# replace the number in the file seg_job.m to fit every sample folder.
        sed -i s/202/${subjectID}/g seg_job.m
