#! /bin/bash

subjects=$HOME/Functional-Connectivity/Subjects/

if [[ -d "${subjects}" ]] ; then
    cd ${subjects}

    if [ ! -d Skull_Stripped_Data ] ; then
        mkdir -p Skull_Stripped_Data/HC
        mkdir -p Skull_Stripped_Data/MDD
    fi

    for category in HC MDD ; do
        pushd ${category}
        for subject in $(ls) ; do
            pushd ${subject}/t1/ > /dev/null
            subject_id=$(echo "${subject}" | cut -d'-' -f2)
            clear -x
            pwd
            echo -e "Performing Skull Strip for subject ${subject} \n" \
                "Subject ID: ${subject_id}\n" \
                "Category: ${category} \n"
            3dSkullStrip -input defaced_mprage.nii -prefix defaced_mprage_${subject_id}.nii
            cp defaced_mprage_${subject_id}.nii ../../../Skull_Stripped_Data/${category}/
            popd > /dev/null
        done
        popd > /dev/null
    done
fi

