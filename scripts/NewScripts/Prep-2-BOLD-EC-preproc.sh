##!/bin/bash
. /etc/profile
#In this script you will preprocess BOLD data
# including slicing timing and head motion correction
Subjects=$1
# define your own working directory
Root_dir=$2

for subject in ${Subjects}
do
cd ${Root_dir}/${subject}

#adjust the input-files to the standard path.
mkdir T1
mv BOLD-${subject}-EC-T1.nii T1/
#----------------adjust end------------------
# exclude the first 4 TRs
# There is two ways to reach the goal:one is to firstly convert DICOM files to AFNI format and then exclude the first 4 TRs
# The other one is to convert DICOM files to NIFTI format and then exclude the first 4 TRs and automaticly output AFNI format files.

rm -f ${subject}-BOLD-EC+*
3dcalc -prefix ${subject}-BOLD-EC-tmp \
-a BOLD-${subject}-EC.nii -expr 'a'
3dcalc -prefix ${subject}-BOLD-EC1 -a ${subject}-BOLD-EC-tmp+orig[10..139] -expr 'a'

## Despiking
rm ${subject}-BOLD-EC+orig*
3dDespike -prefix ${subject}-BOLD-EC ${subject}-BOLD-EC1+orig

## count the outliers in each TR
rm -f outliers-BOLD-EC.1D
3dToutcount -automask -range ${subject}-BOLD-EC+orig > outliers-BOLD-EC.1D

## find the TR with least outliers
base=`cat outliers-BOLD-EC.1D | perl -0777an -F"\n" -e '$i=0; $small=999999; map {/\s*(\d+)/; if ($small > $1) {$small = $1; $ind=$i}; $i++;} @F; print $ind'`

#3dTshift -tpattern alt+z -prefix  ${subject}-BOLD-EC_tshift+orig ${subject}-BOLD-EC+orig

# using the TR with least outliers as base for head motion correction and spatial normalization
rm -f ${subject}-BOLD-EC-base+*
3dcalc -prefix ${subject}-BOLD-EC-base \
-a "${subject}-BOLD-EC+orig[${base}]" -expr 'a'

# slice timing and head motion correction
# head motion parameters are stored in ${subject}-BOLD-EC-motion.1D
# this is the same with running 3dTshift first and then use 3dvolreg it self.
# however, due to the lack of slice scan order, we have to ignore this slice time step.
rm -f ${subject}-BOLD-EC-volreg+* ${subject}-BOLD-EC-motion.1D
3dvolreg -verbose -tshift 0 -base $base -1Dfile ${subject}-BOLD-EC-motion.1D \
-prefix ${subject}-BOLD-EC-volreg ${subject}-BOLD-EC+orig
rm -f ${subject}-BOLD-EC+orig*

## brain mask of the subject
rm -f ${subject}-BOLD-EC-mask+*
3dAutomask -prefix ${subject}-BOLD-EC-mask \
-dilate 1 ${subject}-BOLD-EC-volreg+orig

# maskout the functional BOLD outside of the brain
rm -f ${subject}-BOLD-EC-volreg-mask+orig*
3dcalc -prefix ${subject}-BOLD-EC-volreg-mask \
-a ${subject}-BOLD-EC-volreg+orig \
-b ${subject}-BOLD-EC-mask+orig -expr 'a*b'

gzip *K
done