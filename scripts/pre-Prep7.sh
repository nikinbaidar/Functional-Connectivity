#! /bin/bash

PROJECT_ROOT=/home/nikin/projects/functional_connectivity/preprocessed_data

WORKING_DIR=${PROJECT_ROOT}/Covariates_Removed_data

NORMALIZED_DATA=${PROJECT_ROOT}/Spatially_Normalized_Data
BOLD_fMRI_DATA=${PROJECT_ROOT}/BOLD_fMRI_Data
WMCSFpc3_DATA=${PROJECT_ROOT}/WM-CSF-pca3

# Path to Original Subjects:
SUBJECTS=${PROJECT_ROOT}/../Subjects

# Change into the working directory if it exists
if [ -d ${WORKING_DIR} ]
then
  rm -r ${WORKING_DIR}
fi

mkdir ${WORKING_DIR}
pushd ${WORKING_DIR}

# Create separate directories of HCs and MDDs
CATEGORIES=(HC MDD)

for CATEGORY in "${CATEGORIES[@]}"
do
    mkdir ${CATEGORY}
    pushd ${CATEGORY}

    for SUBJECT in $(ls ${SUBJECTS}/${CATEGORY})
    do
        SUBJECT_ID=$(echo $SUBJECT | cut -d '-' -f 2)

        mkdir Covariates_removed-${SUBJECT_ID}

        # Copy the normalized data
        cp ${NORMALIZED_DATA}/${CATEGORY}/NORM-${SUBJECT_ID}/${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp-bp+tlrc.* \
        ./Covariates_removed-${SUBJECT_ID}/

        # Copy BOLD-EC-motion.1D
        cp ${BOLD_fMRI_DATA}/${CATEGORY}/${SUBJECT_ID}-BOLD-EC-motion.1D \
            ./Covariates_removed-${SUBJECT_ID}/
        
        # Copy wmpc3.1D and csfpc3.1D
        cp ${WMCSFpc3_DATA}/${CATEGORY}/${SUBJECT_ID}-csfpc3.1D  \
            ./Covariates_removed-${SUBJECT_ID}/

        cp ${WMCSFpc3_DATA}/${CATEGORY}/${SUBJECT_ID}-wmpc3.1D  \
            ./Covariates_removed-${SUBJECT_ID}/

    done

    popd
done

popd

tree ${WORKING_DIR}
