#!/bin/bash

PROJECT_ROOT=${HOME}/projects/functional_connectivity/preprocessed_data
WORKING_DIR=${PROJECT_ROOT}/Aligned_Segmented
NORMALIZED_DATA=${PROJECT_ROOT}/Spatially_Normalized_Data
CATEGORIES=(HC MDD)

if [ -d ${WORKING_DIR} ] 
then
  rm -r ${WORKING_DIR}
fi

mkdir ${WORKING_DIR}

# Copy the spatially normalized data of both HCs and MDD patients
# into the working directory.

for CATEGORY in "${CATEGORIES[@]}"
do
  mkdir -p ${WORKING_DIR}/${CATEGORY}

  pushd ${NORMALIZED_DATA}/${CATEGORY}

  for SUBJECT in $(ls)
  do
    cp ${SUBJECT}/0*-T1-NoSkull_shft_alBOLDEC_shft+tlrc.* \
      ${WORKING_DIR}/${CATEGORY}
  done
  popd

  pushd ${WORKING_DIR}/${CATEGORY}

  for SUBJECT in $(ls *.HEAD)
  do
    SUBJECT_ID=$(echo ${SUBJECT} | cut --characters 1-4)
    3dAFNItoNIFTI ${SUBJECT_ID}-T1-NoSkull_shft_alBOLDEC_shft+tlrc.  \
      -prefix ${SUBJECT_ID}-alBOLDEC_shft
  done

  rm *.HEAD
  rm *.BRIK* 

  echo "$(ls *.nii | wc -l) files converted from AFNI to NIfTI"

  popd
done
