#! /bin/bash
#
# .-----------------------------------------------------------------------.
# | .-------------------------------------------------------------------. |
# | | In this script we will spatially normalize the anatomical dataset | |
# | | into MNI space, we will also use the same transformation to       | |
# | | normalize the BOLD dataset into the MNI space.                    | |
# | |___________________________________________________________________| |
# |_______________________________________________________________________|
#
# Define your own working directory
# Note: Whenver you define a directory in a variable, it should not end with
# the '/' character

WORKING_DIR="${HOME}/Functional-Connectivity/Processed_Data/"\
"Spatially_Normalized_Data"

# Create an array with the names of the directory in which the data for healthy
# controls and majorly depressed patient are stored.

CATEGORIES=(HC MDD)

# Note:

############################################################################
# Atlases are downloaded during AFNI installation. To find the location of #
# the atlases run `afni_system_check.py -check_all | grep atlas`. If the   #
# atlases were not downloaded; download them from https://bit.ly/3BpKN2K   #
# Once the tarball has been extracted and placed into whichever location   #
# the afni binaries are stored in, they are immediately available for use. #
############################################################################

# Change into the working directory if it exists

if [ -d "${WORKING_DIR}" ]
then
    pushd ${WORKING_DIR}
else
    echo "${WORKING_DIR}: doesn't exist"
    exit 111;
fi

# Use a nested loop to get into the directory for each subject of each category

for CATEGORY in "${CATEGORIES[@]}"
do
    pushd ${CATEGORY}

    for SUBJECT in $(ls)
    do

        # Grab the SUBJECT_ID
        # Subjects are stored in NORM-SUBJECT_ID
        # Split NORM-SUBJECT_ID at the delimiter and return the specified
        # field
        SUBJECT_ID=$(echo "${SUBJECT}" | cut --delimiter '-' --fields 2)

        pushd ${SUBJECT}

        # Copy the T1 anatomical image 
         cp $HOME/projects/functional_connectivity/Subjects/HC/sub-${SUBJECT_ID}/t1/defaced_mprage.nii ./ANAT-${SUBJECT_ID}.nii

        ###########################################################
        # Spatially normalize the anatomical dataset to MNI space #
        ###########################################################

        # Uniformly distribute the white matter in the brain tissue.

        3dUnifize -prefix BOLD-${SUBJECT_ID}-EC-T1                    \
            -input ANAT-${SUBJECT_ID}.nii

        # Remove the skull and extract the brain tissue from T1-weighted MR
        # image.

        3dSkullStrip -prefix ${SUBJECT_ID}-T1-NoSkull                 \
            -input BOLD-${SUBJECT_ID}-EC-T1+tlrc.

        # Shift the center of DSET to the center of BASE. '_shft' will be
        # appended at the end of DSET. Use the center of mass of the volume as
        # the center (By default, center is the center of volume's grid).

        @Align_Centers -cm                                            \
            -base ${SUBJECT_ID}-BOLD-EC-base+orig.                    \
            -dset ${SUBJECT_ID}-T1-NoSkull+tlrc.

        # Linearly align the anatomical dataset with the EPI dataset. The
        # EPI dataset cab be the functional-MR image. The -epi_base option
        # specifies the starting sub-brick for the alignment.

        align_epi_anat.py -anat ${SUBJECT_ID}-T1-NoSkull_shft+tlrc.   \
            -epi ${SUBJECT_ID}-BOLD-EC-base+orig.                     \
            -epi_base 0                                               \
            -suffix _alBOLDEC                                         \
            -anat_has_skull no                                        \
            -epi_strip 3dAutomask                                     \
            -volreg off                                               \
            -tshift off                                               \
            -resample off

        # Shift (roughly) the center of the aligned anatomical dataset with the
        # standard template in the MNI space. The transformation information
        # will be stored in the base image of BOLD data as well.
        # Again, "_shft" will be appended to the DSET and CHILD.

        # Create a symbolic link for the atlas you want to use.
        # We will use TT_icbm452+tlrc. atals.

        ln -sf /opt/afni/TT_icbm452+tlrc.* ./


        @Align_Centers -base TT_icbm452+tlrc.                         \
            -dset  ${SUBJECT_ID}-T1-NoSkull_shft_alBOLDEC+tlrc.       \
            -child ${SUBJECT_ID}-BOLD-EC-base+orig.

        # Align SOURCE to BASE and save the transformation matrix for each
        # sub-brick into a 1D file. The cost function that defines the matching
        # between SOURCE and BASE is the lpa (Local Pearson Correlation Abs).
        # Also compute a weight function using 3dAutomask alogrithm plus some
        # blurring of the base image.

        3dAllineate -prefix ${SUBJECT_ID}-T1_to_T1_Allineate          \
            -base TT_icbm452+tlrc.                  \
            -source ${SUBJECT_ID}-T1-NoSkull_shft_alBOLDEC_shft+tlrc. \
            -1Dmatrix_save T1_to_T1_Allineate.aff12.1D                \
            -source_automask                                          \
            -cost lpa                                                 \
            -autoweight                                               \
            -cmass

        # Compute a non-linearly warped version of SOURCE dataset to match the
        # BASE dataset. Gaussian blur the SOURCE and BASE before doing the
        # alignmnet. By default, the blur values is 2.345 (for no good reason).
        # Set the blur values to 0 if you do not want to blur the inputs.

        3dQwarp -prefix T1-NoSkull_shft_alBOLDEC_shft                 \
            -blur 0 0                                                 \
            -base TT_icbm452+tlrc.                  \
            -source ${SUBJECT_ID}-T1_to_T1_Allineate+tlrc

        # So, the 3dcopy command seems to overwrite one of the files created
        # above. The old file needs to be deleted for 3dcopy to execute.
        # ${SUBJECT_ID}-T1-NoSkull_shft_alBOLDEC_shft+tlrc.* will be recreated
        # by 3dcopy.
        rm --force ${SUBJECT_ID}-T1-NoSkull_shft_alBOLDEC_shft+tlrc.*

        # Copy one dataset to the other. 3dCopy foo bar copies foo+orig. to
        # bar+orig. or foo+tlrc. to bar+tlrc. This program copies entire
        # datasets and not just sub-bricks.
        3dcopy T1-NoSkull_shft_alBOLDEC_shft                          \
            ${SUBJECT_ID}-T1-NoSkull_shft_alBOLDEC_shft

        #####################################################
        # Spatially normalize the BOLD dataset to MNI space #
        #####################################################

        # Create a copy of the original volume registartion mask.
        3dcopy ${SUBJECT_ID}-BOLD-EC-volreg-mask+orig.                \
            ${SUBJECT_ID}-BOLD-EC-volreg-mask_temp

        # Shift (roughly) the center of the 4D BOLD fMRI data to the space
        # using the same parameters as the base image. The base image has
        # similar alignmnet as the anatomical image. (As explained earlier).
        @Align_Centers -cm                                            \
            -base ${SUBJECT_ID}-BOLD-EC-base_shft+orig                \
            -dset ${SUBJECT_ID}-BOLD-EC-volreg-mask_temp+orig.

        ## Apply a nonlinear transformation and resample to 3x3x3 mm
        3dNwarpApply -prefix ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp       \
            -source ${SUBJECT_ID}-BOLD-EC-volreg-mask_temp_shft+orig. \
            -nwarp 'T1-NoSkull_shft_alBOLDEC_shft_WARP+tlrc. '\
            'T1_to_T1_Allineate.aff12.1D'

        3dcopy ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp+orig                \
            ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp_Backup

        3drefit -view tlrc ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp+orig

        ##get tissuse-based signal before smooth
        3dDeconvolve -float -polort A                                 \
            -errts ${SUBJECT_ID}-BeforeSmooth-lp                      \
            -bucket BeforeSmooth-bucket                               \
            -input ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp+tlrc.

        3dBandpass -band 0.01 0.08                                    \
            -prefix ${SUBJECT_ID}-BeforeSmooth-lp-bp                  \
            -input ${SUBJECT_ID}-BeforeSmooth-lp+tlrc

        # Spatial smoothing with 6 mm FWHM. The value for FWHM is adjustable
        3dmerge -doall                                                \
            -1blur_fwhm 6                                             \
            -prefix ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6          \
            ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp+tlrc

        # Linear detrending
        3dDeconvolve -float -polort A                                 \
            -bucket bucket                                            \
            -errts ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp        \
            -input ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6+tlrc.

        # temporal filtering band pass 0.01-0.1 Hz
        # you can modify the filter if you you want

        3dBandpass -band 0.01 0.08                                    \
            -prefix ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp-bp    \
            -input ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp+tlrc

        3dresample -master TT_icbm452+tlrc.                           \
            -prefix ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp-bp-resampled \
            -input ${SUBJECT_ID}-BOLD-EC-volreg-Nwarp-blur6-lp-bp+tlrc.

        gzip *K

        popd

    done

    popd

done

popd

if which tree
then
    tree ${WORKING_DIR}
fi
