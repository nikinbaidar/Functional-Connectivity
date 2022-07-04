#! /bin/bash

PROJECT_ROOT=${HOME}/projects/functional_connectivity/preprocessed_data/
WORKING_DIR=${PROJECT_ROOT}/WM-CSF-pca3
CATEGORIES=(HC MDD)
MARKERS=(c2 c3)
TISSUES=(CSF WhiteMatter)

pushd ${WORKING_DIR}

for CATEGORY in "${CATEGORIES[@]}"
do
  rm -rf ${CATEGORY}
  mkdir -p ${CATEGORY}

  # Copy segmented CSF and WhiteMatter images data into the working 
  # directory.
  pushd ${CATEGORY} 

  for TISSUE in "${TISSUES[@]}"
  do
    DATA=${PROJECT_ROOT}/Aligned_Segmented/${CATEGORY}/${TISSUE}
    cp ${DATA}/* ${WORKING_DIR}/${CATEGORY}
  done

  # Copy the spatially normalized '#-BeforeSmooth-lp-bp' data into the
  # working directory.

  pushd ${PROJECT_ROOT}/Spatially_Normalized_Data/${CATEGORY}

  for SUBJECT in $(ls)
  do
    cp ${SUBJECT}/0*BeforeSmooth-lp-bp+tlrc.* ${WORKING_DIR}/${CATEGORY}
  done

  popd
  # HC

  for SUBJECT in $(ls *.HEAD)
  do
    SUBJECT_ID=$(echo ${SUBJECT} | cut --characters 1-4)

    for MARKER in "${MARKERS[@]}"
    do
      3dcalc -a ${MARKER}${SUBJECT_ID}-alBOLDEC_shft.nii -expr 'a' \
        -prefix ${MARKER}${SUBJECT_ID}-alBOLDEC_shft

      3dcalc -a ${MARKER}${SUBJECT_ID}-alBOLDEC_shft+tlrc -expr 'step(a-0.96)' \
        -datum byte -prefix ${SUBJECT_ID}-temp-${MARKER}Mask

      3dfractionize -input ${SUBJECT_ID}-temp-${MARKER}Mask+tlrc \
        -template ${SUBJECT_ID}-BeforeSmooth-lp-bp+tlrc \
        -prefix ${SUBJECT_ID}-${MARKER}Mask -vote clip 0.8

      3dmask_tool -input ${SUBJECT_ID}-${MARKER}Mask+tlrc \
        -prefix ${SUBJECT_ID}-${MARKER}Mask-erode

      if [ "${MARKER}" = "c2" ]
      then
        3drename ${SUBJECT_ID}-${MARKER}Mask-erode+tlrc ${SUBJECT_ID}-WMmask

        3dmaskdump -mask ${SUBJECT_ID}-WMmask+tlrc  \
          -noijk ${SUBJECT_ID}-BeforeSmooth-lp-bp+tlrc > ${SUBJECT_ID}_wm.1D

        1dsvd -vmean -1Dleft -nev 3 ${SUBJECT_ID}_wm.1D\'  | \
          grep -v "#" > ${SUBJECT_ID}-wmpc3.1D

      elif [ "${MARKER}" = "c3" ]
      then
        3drename ${SUBJECT_ID}-${MARKER}Mask-erode+tlrc ${SUBJECT_ID}-CSFmask

        3dmaskdump -mask ${SUBJECT_ID}-CSFmask+tlrc  \
          -noijk ${SUBJECT_ID}-BeforeSmooth-lp-bp+tlrc > ${SUBJECT_ID}_csf.1D

        1dsvd -vmean -1Dleft -nev 3 ${SUBJECT_ID}_csf.1D\'  | \
          grep -v "#" > ${SUBJECT_ID}-csfpc3.1D
      fi

    done

  done

  popd
  pwd

done
