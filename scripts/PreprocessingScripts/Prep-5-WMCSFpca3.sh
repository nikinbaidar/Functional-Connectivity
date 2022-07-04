#!/bin/bash
. /etc/profile

#**********************************************************
ARClist=$1
# define your own working directory
rtpath=$2

marker='c2 c3'
fname=BeforeSmooth-ld-bp; view=tlrc
#**********************************************************

rm -rf ${rtpath}/temp
mkdir -p ${rtpath}/temp
tempdir=${rtpath}/temp

cd ${rtpath}/${ARClist}/reCovariates
mv c2${ARClist}-anat.nii ${ARClist}-c2+tlrc.nii
mv c3${ARClist}-anat.nii ${ARClist}-c3+tlrc.nii

for s in ${ARClist}
do

#--------adjust inputfiles to the standard input path-------
  cp ../T1/${s}-${fname}+tlrc* ./

#-----------------------adjust end--------------------------
  for m in ${marker}
  do
	rm  -f $s-csfpc3.1D
	rm  -f $s-wmpc3.1D
        rm -f temp*
# the values at each voxel in spm12/white.nii are the possibility of it's belonging, and the values at ${s}-${m}+orig.nii is 1, and possibility at it's edge.
# 0.99 means the thresold, when we make it smaller, we can get more area of ./${s}-${m}+tlrc.nii, to make it greater, we can get more strict mask of ./${s}-${m}+tlrc.nii
# when it's WM or CSF, we want to make it greater, so after we remove covariates, we can get more brain grey matter areas, the same aim is true for grey matter, we want to make it smaller to get
# more grey matter areas
      3dcalc -a ./${s}-${m}+tlrc.nii -expr 'step(a-0.96)' \
     -datum byte -prefix temp-${m}-mask
# the value at each voxel changes to 0 and 1.
      rm -f ${s}-${m}mask+tlrc*
      rm -f fractionize+tlrc*
	3dfractionize -input temp-${m}-mask+tlrc -template ${s}-${fname}+tlrc  \
      -prefix $s-${m}mask -vote  -clip 0.8

#####apply erosions to c2 and c3 masks to make them even smaller and clustered
        rm -f ${s}-${m}mask-erode*
	3dmask_tool -input ${s}-${m}mask+tlrc -prefix ${s}-${m}mask-erode
  done
#
#####rename the eroded c2 and c3 masks to WM and CSF masks
#
   rm -f ${s}-WMmask+tlrc.* ${s}-CSFmask+tlrc.* ${s}-mask+tlrc.*
   3drename ${s}-c2mask-erode+tlrc ${s}-WMmask
   3drename ${s}-c3mask-erode+tlrc ${s}-CSFmask
#   rm -f temp*
#
   cp ${s}-c2mask+tlrc.* ${tempdir}
   cp ${s}-c3mask+tlrc.* ${tempdir}

   3dmaskdump -mask ${s}-WMmask+tlrc -noijk ${s}-${fname}+${view} > ${tempdir}/${s}_mytmpw.1D
   3dmaskdump -mask ${s}-CSFmask+tlrc -noijk ${s}-${fname}+${view} > ${tempdir}/${s}_mytmpc.1D

#   rm mytmp*.1D
done

cd $tempdir
for s in ${ARClist}
do
rm -f $s-csfpc3.1D
1dsvd -vmean -1Dleft -nev 3 ${tempdir}/${s}_mytmpc.1D\' | grep -v "#" > $s-csfpc3.1D
1dsvd -vmean -1Dleft -nev 3 ${tempdir}/${s}_mytmpw.1D\' | grep -v "#" > $s-wmpc3.1D
done

cd $tempdir
for s in ${ARClist}
do
mv  $s-csfpc3.1D ${rtpath}/$s
mv  $s-wmpc3.1D ${rtpath}/$s
done
