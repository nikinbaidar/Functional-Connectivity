#! /bin/bash
# AFNI commands will be labeled steps

# Source /etc/profile, I want to skip this becuase I have set my own profile
# . /etc/profile

###############################################################
# In this script you will preprocess BOLD data (4D fMRI data) #
# including slicing timing and head motion correction         #
###############################################################

# Subjects=$1 (I want my script to do this itself without me having to specify
# the subjects on the command line each time)

# Define your own working directory
# For me this is $HOME/Functional-Connectivity/Processed_Data/BOLD_fMRI_Data

Working_Dir=$HOME/Functional-Connectivity/Processed_Data/BOLD_fMRI_Data

# Move to the working directory
pushd ${Working_Dir}

for category in HC MDD
do
    pushd ${category}
    for BOLD_data in $(ls *.nii)
    do

        # Did this part already
        # adjust the input-files to the standard path.
        # mkdir T1
        # mv BOLD-${subject}-EC-T1.nii T1/
        # rm -f ${subject}-BOLD-EC+*

        # ----------------------------adjust end-------------------------------

        # Exclude the first 4 TRs. There is two ways to reach this goal:
        # 1. Firstly convert DICOM files to AFNI format and then exclude the
        #    first 4 TRs.
        # 2. The other one is to convert DICOM files to NIFTI format
        #    and then exclude the first 4 TRs and automaticly output AFNI format
        #    files.

        subject_id=$(basename -s .nii ${BOLD_data} | cut -d '_' -f 2)

        echo -e "Current subject is sub-${subject_id} of category ${category}\n"

        # Step 0:

        #############################################################
        # Convert a dataset from NIfTI to .BRIK and .HEAD           #
        # -verbose because I want to be able to see what's going on #
        #############################################################

        rm -f ${subject_id}-BOLD-EC-tmp*
        rm -f ${subject_id}-BOLD-EC*

        3dcalc -prefix ${subject_id}-BOLD-EC-tmp \
            -a ${BOLD_data} -expr 'a' -verbose

        # Step 1:

        # Exclude the first 5 TRs

        # In the previous step, ${subject}-BOLD-EC-tmp+orig.HEAD and
        # ${subject}-BOLD-EC-tmp+orig.BRIK files were created.
        # the command:

        3dcalc -prefix ${subject_id}-BOLD-EC1 \
            -a ${subject_id}-BOLD-EC-tmp+orig[5..$] -expr 'a'

        # Step 2:
        ## Despiking

        3dDespike -prefix ${subject_id}-BOLD-EC ${subject_id}-BOLD-EC1+orig

        ## count the outliers in each TR
        3dToutcount -automask -range ${subject_id}-BOLD-EC+orig > outliers-BOLD-EC.1D

        ## find the TR with least outliers
        base=$(cat outliers-BOLD-EC.1D | \
            perl -0777an -F"\n" -e \
            '$i=0;
            $small=999999;
            map {
                /\s*(\d+)/;
                if ($small > $1) {
                    $small = $1;
                    $ind=$i;
                };
                $i++;
            } @F;
            print $ind')

            echo The value for base is $base
            sleep 5

        #3dTshift -tpattern alt+z -prefix  ${subject}-BOLD-EC_tshift+orig ${subject}-BOLD-EC+orig

        # using the TR with least outliers as base for head motion correction and spatial normalization
        3dcalc -prefix ${subject_id}-BOLD-EC-base \
            -a "${subject_id}-BOLD-EC+orig[${base}]" -expr 'a'

        # slice timing and head motion correction
        # head motion parameters are stored in ${subject}-BOLD-EC-motion.1D
        # this is the same with running 3dTshift first and then use 3dvolreg it self.
        # however, due to the lack of slice scan order, we have to ignore this slice time step.

        ###################################
        # A file is missing for the next command
        ###################################

        # 3dvolreg -verbose -tshift 0 -base $base -1Dfile ${subject}-BOLD-EC-motion.1D \
        #     -prefix ${subject}-BOLD-EC-volreg ${subject}-BOLD-EC+orig
        #     rm -f ${subject}-BOLD-EC+orig*

        3dvolreg -verbose -tshift 0 -base ${base} -1Dfile outliers-BOLD-EC.1D \
            -prefix ${subject_id}-BOLD-EC-volreg ${subject_id}-BOLD-EC+orig

        ## brain mask of the subject
        3dAutomask -prefix ${subject_id}-BOLD-EC-mask \
            -dilate 1 ${subject_id}-BOLD-EC-volreg+orig

        # maskout the functional BOLD outside of the brain
        3dcalc -prefix ${subject_id}-BOLD-EC-volreg-mask \
            -a ${subject_id}-BOLD-EC-volreg+orig \
            -b ${subject_id}-BOLD-EC-mask+orig -expr 'a*b'

        gzip *K
    done
    popd
done

