#!/bin/bash
. /etc/profile

ARC=$1
rtpath=$2

#remove covariates
for s in ${ARC}
do
  cd ${rtpath}/${s}/reCovariates
  rm ${s}-BOLD-EC-volreg-Nwarp-blur6-ld-bp+tlrc*
cp ../T1/${s}-BOLD-EC-volreg-Nwarp-blur6-ld-bp+tlrc* ./
#rm -f ${s}-wm.1D
#3dmaskave -mask ${s}-WMmask+tlrc -mrange 1 1 -quiet ${s}-BOLD-EC-volreg-lp-dt_shft-blur6+tlrc > ${s}-wm.1D
#rm -f ${s}-csf.1D
#3dmaskave -mask ${s}-CSFmask+tlrc -mrange 1 1 -quiet ${s}-BOLD-EC-volreg-lp-dt_shft-blur6+tlrc > ${s}-csf.1D

##clac the first order derivation of motion parameters
#1d_tool.py -infile ${rtpath}/${s}/${s}-BOLD-EC-motion.1D -set_nruns 1 -derivative -write motion_1stDerivatives.1D
#mv motion_1stDerivatives.1D ../

#there can't be comments or empty lines within a command.
#the -mask option should be replaced by your GMmask which comes from the average of your samples GMmask after segment.
cd ..
rm -f ${s}_rest_errt+*
rm -f *-buc-errt*
3dDeconvolve \
-input ${rtpath}/${s}/reCovariates/${s}-BOLD-EC-volreg-Nwarp-blur6-ld-bp+tlrc \
-automask \
-polort A -jobs 8 -float \
-num_stimts 8 \
-stim_file 1 ${s}-BOLD-EC-motion.1D'[0]' -stim_label 1 "roll" \
-stim_file 2 ${s}-BOLD-EC-motion.1D'[1]' -stim_label 2 "pitch" \
-stim_file 3 ${s}-BOLD-EC-motion.1D'[2]' -stim_label 3 "yaw" \
-stim_file 4 ${s}-BOLD-EC-motion.1D'[3]' -stim_label 4 "IS" \
-stim_file 5 ${s}-BOLD-EC-motion.1D'[4]' -stim_label 5 "RL" \
-stim_file 6 ${s}-BOLD-EC-motion.1D'[5]' -stim_label 6 "AP" \
-stim_file 7 ${s}-wmpc3.1D'[0]' -stim_label 7 "WMpc1" \
-stim_file 8 ${s}-csfpc3.1D'[0]' -stim_label 8 "CSFpc1" \
-goforit 4 \
-errts ${s}_rest_errt -bucket ${s}-buc-errt


done
