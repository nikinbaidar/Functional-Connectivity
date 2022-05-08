#!/usr/bin/env bash

WORKING_DIR="${HOME}/Functional-Connectivity/Processed_Data/CommonGM_Mask"

# Path to segmented grey matter image data for all subjects.
x="$HOME/Functional-Connectivity/Processed_Data/Aligned_Segmented/GreyMatter"

if ! [ -d "${WORKING_DIR}" ]
then
    mkdir ${WORKING_DIR}
fi

pushd ${WORKING_DIR}

rm -r *

# Copy all segmented grey matter image data into the working directory.
cp -r ${x}/*.nii ./

# Initialize an empty string
allSubjects=""

for FILE in $(ls)
do
  # Concatnate names of all the files
  allSubjects+=" ${FILE} "
done

3dmerge -gmean -prefix average-c1+tlrc ${allSubjects}
 
3dcalc -a average-c1+tlrc. -expr 'step(a-0.35)' \
  -datum byte -prefix CommonGMmask

# Organize Files

mkdir grey_matter_Segmented
mkdir average

mv *.nii grey_matter_Segmented
mv average-c1+tlrc.* average
