#!/bin/bash
GMMaskPath="/home/nikin/projects/functional_connectivity/preprocessed_data/CommonGM_Mask/CommonGMmask+tlrc."

atlas="/home/nikin/projects/functional_connectivity/fc_analysis/roi_selection/BNA_MPM_thr25_1.25mm+tlrc"

SUBJECT_ID=0349

#################################################
# r_rHipp= right rostal hippocampus, range=216  #
# r_cHipp= right caudal hippocampus, range=218  #

# l_dCa= left dorsal caudate, range=227   #
#################################################

#**********************************************************************************************************************#
# Resample the common gray matter mask to prevent the error: incompatible dimensions
3dresample -master ./${SUBJECT_ID}_rest_errt+tlrc -prefix CommonGMmask -input ${GMMaskPath}
#**********************************************************************************************************************#

rm -f ${SUBJECT_ID}_BNA_Atlas_Mask+tlrc.*
3dresample -master ${SUBJECT_ID}_rest_errt+tlrc \
  -prefix ${SUBJECT_ID}_BNA_Atlas_Mask -input ${atlas}

count=0

ROIs='r_rHipp r_cHipp l_vCa l_dCa'
range=(216 218 219 227)

for roi in ${ROIs}; do
  3dmaskave -mask ${SUBJECT_ID}_BNA_Atlas_Mask+tlrc -quiet \
    -mrange ${range[$count]} ${range[$count]}              \
    ${SUBJECT_ID}_rest_errt+tlrc > ${SUBJECT_ID}_${roi}.1D

  rm --force ${SUBJECT_ID}_${roi}_cc+tlrc.*
  rm --force ${SUBJECT_ID}_${roi}_z+tlrc.*

  3dDeconvolve -input ${SUBJECT_ID}_rest_errt+tlrc \
    -mask ./CommonGMmask+tlrc \
    -jobs 8 -float \
    -GOFORIT 10 \
    -num_stimts 1 \
    -stim_file 1 ${SUBJECT_ID}_${roi}.1D \
    -stim_label 1 "${SUBJECT_ID}" \
    -tout -rout -bucket ${SUBJECT_ID}_buc

  3dcalc -a ${SUBJECT_ID}_buc+tlrc'[4]' -b ${SUBJECT_ID}_buc+tlrc'[2]' \
    -expr "ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)"           \
    -prefix ${SUBJECT_ID}_${roi}_cc

  3dcalc -a ${SUBJECT_ID}_${roi}_cc+tlrc -expr "0.5*log((1+a)/(1-a))"  \
    -datum float -prefix ${SUBJECT_ID}_${roi}_z

  rm -f ${SUBJECT_ID}_buc+tlrc.*
  rm -f ${SUBJECT_ID}_${roi}.1D

  ((count++))
done
