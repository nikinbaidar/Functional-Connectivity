#!/bin/bash

PROJECT_ROOT=/home/nikin/projects/functional_connectivity/preprocessed_data
WORKING_DIR=${PROJECT_ROOT}/Covariates_Removed_data
CATEGORIES=(HC MDD)

pushd ${WORKING_DIR}

for CATEGORY in "${CATEGORIES[@]}"
do
  pushd ${CATEGORY}

  for SUBJECT in $(ls)
  do
    SUBJECT_ID=$(echo ${SUBJECT} | cut --delimiter '-' --field 2)

    pushd ${SUBJECT}

    rm -f ${SUBJECT_ID}_rest_errt+*
    rm *.err
    rm -f *-buc-errt*

    3dDeconvolve                                                               \
      -input ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp-bp+tlrc.                       \
      -automask                                                                \
      -polort A -jobs 8 -float                                                 \
      -num_stimts 8                                                            \
      -stim_file 1 ${SUBJECT_ID}-BOLD-EC-motion.1D'[0]' -stim_label 1 "roll"   \
      -stim_file 2 ${SUBJECT_ID}-BOLD-EC-motion.1D'[1]' -stim_label 2 "pitch"  \
      -stim_file 3 ${SUBJECT_ID}-BOLD-EC-motion.1D'[2]' -stim_label 3 "yaw"    \
      -stim_file 4 ${SUBJECT_ID}-BOLD-EC-motion.1D'[3]' -stim_label 4 "IS"     \
      -stim_file 5 ${SUBJECT_ID}-BOLD-EC-motion.1D'[4]' -stim_label 5 "RL"     \
      -stim_file 6 ${SUBJECT_ID}-BOLD-EC-motion.1D'[5]' -stim_label 6 "AP"     \
      -stim_file 7 ${SUBJECT_ID}-wmpc3.1D'[0]'          -stim_label 7 "WMpc1"  \
      -stim_file 8 ${SUBJECT_ID}-csfpc3.1D'[0]'         -stim_label 8 "CSFpc1" \
      -goforit 4                                                               \
      -errts ${SUBJECT_ID}_rest_errt -bucket ${SUBJECT_ID}-buc-errt

    popd
  done

  popd
done

popd
