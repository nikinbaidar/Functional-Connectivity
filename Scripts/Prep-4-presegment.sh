#!bin/bash
. /etc/profile
# use SPM to do segmentation after this step,to adapt the AFNI format file to NIFTI format
ARC=$1
rtpath=$2

for s in ${ARC}
do
  cd ${rtpath}/${s}
#--------adjust the input-files to the standard input-path---------
  mkdir reCovariates
  cd ./reCovariates
  cp ../T1/${s}-anat-ns_shft_alBOLDEC_shft+tlrc* ./
#---------------------------adjust end-----------------------------	
  3dAFNItoNIFTI -prefix $s-anat.nii ${s}-anat-ns_shft_alBOLDEC_shft+tlrc
done



