#!/bin/tcsh
# simple script to deface an anatomical MRI dataset
# the output may be used as a mask with other datasets
#  like CT
# the procedure requires an AFNI computed standard space
# version with the origin at the AC (anterior commissure)
#  so TLRC or MNI_ANAT space datasets
# usage:
# deface_anat.csh anat+orig anat+tlrc strip+orig
#
# 3 datasets are used as input
# anat+orig - an anatomical dataset in its original space
# anat+tlrc - an anatomical dataset aligned to a Talairach space template
#             should be made with @auto_tlrc with affine transformation
#             in header. AFNI manual talairach also works.
# strip+orig - a skullstripped dataset in its original space

# for datasets that have been affinely aligned to TLRC space
# probably with something like:
# @auto_tlrc -base TT_N27+tlrc -input anat+orig

set anat = $1
set anattlrc = $2
set anatstrip = $3

echo "0 0 0" > 000.1D

set ACorig = `Vecwarp -apar $anattlrc -input 000.1D -backward`

3dcalc -a $anat -b $anatstrip -expr "a*step(b)+a*(not(step(b))*step(step(y-(${ACorig[2]})+15)+step(z+(${ACorig[3]})+5)))" -RAI -prefix anat_deface -overwrite


