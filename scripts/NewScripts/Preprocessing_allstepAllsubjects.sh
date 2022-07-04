#!/bin/bash
. /etc/profile

#this file is aiming at the totally batch preprocessing of raw data
#first, we should use list.sh to make sure that the dataset folders structure are in the standard format.
#and then except the outliers to the test conditions.

#######settings for the processing########
#set MATLABPATH for seg.m to make sure it can be found easily.
#echo "export MATLABPATH=/home/rp/Data/aMCI/sub201:$MATLABPATH" >> /home/rp/.bash_profile
#. /home/rp/.bash_profile
#######setting end#######

#for s in /home/rp/ADNI/NC/*
#do
#        subjectID=${s##*/}
#       		cd ${s}
#       		sh ../../script/Prep-1-allocateSegbatch.sh  ${subjectID} /home/rp/ADNI/NC  
#		sh ../../script/Prep-2-BOLD-EC-preproc.sh  ${subjectID} /home/rp/ADNI/NC
#   		sh ../../script/Prep-3-BOLD-EC-align-to-anat-MNI1.sh ${subjectID} /home/rp/ADNI/NC
#   		sh ../../script/Prep-4-presegment.sh ${subjectID} /home/rp/ADNI/NC
#   		matlab -nojvm -r "seg('${s}/seg_job.m');exit"
#		#the code in Prep-5-genWMCSFmask.sh has been included in the file Prep-6-WMCSFpca3.sh,we just omit Prep-5.
#	  	#sh ../../script/Prep-5-genWMCSFmask.sh ${subjectID} /home/rp/Data/aMCI
#	   	sh ../../script/Prep-5-WMCSFpca3.sh ${subjectID} /home/rp/ADNI/NC
#	   	#sh ../../script/Prep-7-reCovariates.sh ${subjectID} /home/rp/ADNI/NC
#done
##
##
#for s in /home/rp/ADNI/MCI/*
#do
#        subjectID=${s##*/}
#   	cd ${s}
#	if [ ${subjectID} != 'temp' ]
#	then
#	        sh ../../script/Prep-1-allocateSegbatch.sh ${subjectID} /home/rp/ADNI/MCI  
#		sh ../../script/Prep-2-BOLD-EC-preproc.sh  ${subjectID} /home/rp/ADNI/MCI
#   		sh ../../script/Prep-3-BOLD-EC-align-to-anat-MNI1.sh ${subjectID} /home/rp/ADNI/MCI
#   		sh ../../script/Prep-4-presegment.sh ${subjectID} /home/rp/ADNI/MCI
#   		matlab -nojvm -r "seg('${s}/seg_job.m');exit"
#		#the code in Prep-5-genWMCSFmask.sh has been included in the file Prep-6-WMCSFpca3.sh,we just omit Prep-5.
#	  	#sh ../../script/Prep-5-genWMCSFmask.sh ${subjectID} /home/rp/Data/NC
#	   	sh ../../script/Prep-5-WMCSFpca3.sh ${subjectID} /home/rp/ADNI/MCI
#	   	#sh ../../script/Prep-7-reCovariates.sh ${subjectID} /home/rp/ADNI/MCI
#	fi
#done
#
#for s in /home/rp/ADNI/Dementia/*
#do
#        subjectID=${s##*/}
#        cd ${s}
#	if [ ${subjectID} != 'temp' ]
#	then
#       	 	sh ../../script/Prep-1-allocateSegbatch.sh ${subjectID} /home/rp/ADNI/Dementia
#    	   	sh ../../script/Prep-2-BOLD-EC-preproc.sh  ${subjectID} /home/rp/ADNI/Dementia
#       		sh ../../script/Prep-3-BOLD-EC-align-to-anat-MNI1.sh ${subjectID} /home/rp/ADNI/Dementia
#   	     	sh ../../script/Prep-4-presegment.sh ${subjectID} /home/rp/ADNI/Dementia
#       		matlab -nojvm -r "seg('${s}/seg_job.m');exit"
#      		#the code in Prep-5-genWMCSFmask.sh has been included in the file Prep-6-WMCSFpca3.sh,we just omit Prep-5.
#     		#sh ../../script/Prep-5-genWMCSFmask.sh ${subjectID} /home/rp/Data/NC
#      		sh ../../script/Prep-5-WMCSFpca3.sh ${subjectID} /home/rp/ADNI/Dementia
#       		#sh ../../script/Prep-7-reCovariates.sh ${subjectID} /home/rp/ADNI/Dementia
#	fi
#done

# generate averagedGMmask after segment of all the samples.
# ignore for using at present, for the generaged GM mask can't cover all of the ch4 mask, we just use the -automask in 3dDeconvolve.
##sh /home/rp/ADNI/script/Prep-6-GenerateCommonWMmask.sh /home/rp/ADNI/mask 

# clear and prepare the environment of scrubbing
#matlab -nojvm -r "recover_environment();exit"

# use the averaged GMmask for remove of covariates.
for s in /home/rp/ADNI/NC/*
do
     subjectID=${s##*/}
     if [ ${subjectID} != 'temp' ]
     then
    	 cd ${s}          
#    	 sh ../../script/Prep-7-reCovariates.sh ${subjectID} /home/rp/ADNI/NC
       matlab -nojvm -r "Scrubbing_Correction('$s','$subjectID');exit"
     fi
done

for s in /home/rp/ADNI/MCI/*
do
     subjectID=${s##*/}
     if [ ${subjectID} != 'temp' ]
     then
	     cd ${s}          	
#     	sh ../../script/Prep-7-reCovariates.sh ${subjectID} /home/rp/ADNI/MCI
       matlab -nojvm -r "Scrubbing_Correction('$s','$subjectID');exit"
     fi
done


for s in /home/rp/ADNI/Dementia/*
do
     subjectID=${s##*/}	
     if [ ${subjectID} != 'temp' ]
     then	
        cd ${s}          
#        sh ../../script/Prep-7-reCovariates.sh ${subjectID} /home/rp/ADNI/Dementia
        matlab -nojvm -r "Scrubbing_Correction('$s','$subjectID');exit"
     fi
done