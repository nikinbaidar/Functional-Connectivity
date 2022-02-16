#! /bin/bash

# Define a working directory
WORKING_DIR=${HOME}/Functional-Connectivity/Processed_Data/Normalized_Data

# Path to BOLD fMRI Data:
BOLD_DATA=${HOME}/Functional_Connectivity/Processed_Data/BOLD_fMRI_Data

# Path to Original Subjects:
SUBJECTS=${HOME}/Functional_Connectivity/Subjects

# Change into the working directory if it exists
if [ -d ${WORKING_DIR} ]
then
    pushd ${WORKING_DIR}
    # rm -rf *
else
    echo "${WORKING_DIR}: doesn't exist"
    exit 111;
fi

# Create separate directories of HCs and MDDs
mkdir ./HC ./MDD

CATEGORIES=(HC MDD)

for CATEGORY in "${CATEGORIES[@]}"
do
    pushd ${CATEGORY}

    for SUBJECT in $(ls ${SUBJECTS}/${CATEGORY})
    do
        SUBJECT_ID=$(echo $SUBJECT | cut -d '-' -f 2)

        if ! [ -d ${SUBJECT_ID} ]
        then
            mkdir NORM-${SUBJECT_ID}
        fi

        # Copy original t1 image with skull for each subject
        cp ${SUBJECTS}/${CATEGORY}/${SUBJECT}/t1/defaced_mprage.nii \
            NORM-${SUBJECT_ID}/ANAT-${SUBJECT_ID}.nii

        # Copy the base fMRI data
        cp ${BOLD_DATA}/${CATEGORY}/${SUBJECT_ID}-BOLD-EC-base+orig* \
            NORM-${SUBJECT_ID}/

        # Copy the Volreg Mask
        cp ${BOLD_DATA}/${CATEGORY}/${SUBJECT_ID}-BOLD-EC-volreg-mask+orig* \
            NORM-${SUBJECT_ID}/
    done

    # Copy the base fMRI file and the volreg mask for all subjects in the
    # current directory
    # cp "${BOLD_DATA}/${CATEGORY}/*-BOLD-EC-base+orig*" ./

    popd
done

popd;

tree ${WORKING_DIR}
