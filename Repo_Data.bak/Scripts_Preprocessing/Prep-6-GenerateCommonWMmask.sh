# the script aims to generate the average GM mask from all the samples we use rather than using CommonGMmask.
# however, if you want to use this script, please check after you the result for it's effect, especially for the parameter dilate and erode in 3dmask_tool command.

# specify the path for storage of mask
maskPath=$1

str=""

cd $maskPath
for path in /home/rp/ADNI/NC/*
do
    subjectID=${path##*/}
    str=$str" ${path}/reCovariates/c1$subjectID-anat.nii"
done    
    
for path in /home/rp/ADNI/MCI/*
do
    subjectID=${path##*/}
    str=$str" ${path}/reCovariates/c1$subjectID-anat.nii"
done

for path in /home/rp/ADNI/Dementia/*
do
    subjectID=${path##*/}
    str=$str" ${path}/reCovariates/c1$subjectID-anat.nii"
done
   
3dmerge -gmean -prefix averaged-c1+tlrc $str


#**********************************************************
# define your own working directory
fname=BOLD-EC-volreg-lp-dt_shft
m=c1
#**********************************************************
cp /home/rp/ADNI/NC/002_S_0295/T1/002_S_0295-${fname}+tlrc* ./
#-----------------------adjust end--------------------------
# the values at each voxel in spm12/white.nii are the possibility of it's belonging, and the values at ${s}-${m}+orig.nii is 1, and possibility at it's edge.
# 0.99 means the thresold, when we make it smaller, we can get more area of ./${s}-${m}+tlrc.nii, to make it greater, we can get more strict mask of ./${s}-${m}+tlrc.nii
# when it's WM or CSF, we want to make it greater, so after we remove covariates, we can get more brain grey matter areas, the same aim is true for grey matter, we want to make it smaller to get
# more grey matter areas
      rm -f temp* 
      3dcalc -a ./averaged-${m}+tlrc -expr 'step(a-0.35)' \
      -datum byte -prefix temp-${m}-mask
# the value at each voxel changes to 0 and 1.
#      rm -f 002_S_0295-${m}mask+tlrc*
#      rm -f fractionize+tlrc*
#      3dfractionize -input temp-${m}-mask+tlrc -template 002_S_0295-${fname}+tlrc  \
#      -prefix 002_S_0295-${m}mask -vote  -clip 0.8
#####apply erosions to c1 mask to make them even smaller and clustered
#      rm -f averaged-${m}mask-erode*
#      3dmask_tool -input 002_S_0295-${m}mask+tlrc -prefix averaged-${m}mask-erode -dilate_inputs 2 -3
#####rename the eroded c1 masks to GM masks
#      rm averaged-GMmask*
#      3drename averaged-c1mask-erode+tlrc averagedGMmask
       3drename temp-c1-mask averagedGMmask
