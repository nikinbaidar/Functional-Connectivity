#! /bin/bash
WORKING_DIR="${HOME}/functional_connectivity/fc_analysis/clusters"
GMMaskPath="${HOME}/functional_connectivity/fc_analysis/roi_selection"\
"/HC/ROI-0236/CommonGMmask+tlrc"

subjectCount=30
dist=4.3
pth1=0.001
pth2=0.005
pth3=0.01
pth4=0.05

cd ${WORKING_DIR}

for SUBJECT_ID in "${AllSubs[@]}"
do
  COVARIATE_REMOVED="${HOME}/projects/functional_connectivity/preprocessed_data/Covariates_Removed_data/MDD/Covariates_removed-${SUBJECT_ID}/${SUBJECT_ID}_rest_errt+tlrc"
  rm 3dFWHMx.1D* 		
  3dFWHMx -dset $COVARIATE_REMOVED -automask \
      -detrend -unif -acf > ${SUBJECT_ID}-acf.1D
  cp 3dFWHMx.1D.png ${SUBJECT_ID}_3dFWHMx.1D.png
done

cat *-acf.1D > all_ACF_temp.txt
cat all_ACF_temp.txt | awk 'NR%2==0' > all_ACF.txt
rm all_ACF_temp.txt

a=(`1dsum all_ACF.txt`)

ACFa=`ccalc ${a[0]}/${subjectCount}`
ACFb=`ccalc ${a[1]}/${subjectCount}`
ACFc=`ccalc ${a[2]}/${subjectCount}`
ACFd=`ccalc ${a[3]}/${subjectCount}`
echo $ACFd > avg_ACF.txt

3dClustSim -mask ${GMMaskPath} -acf ${ACFa} ${ACFb} ${ACFc} \
  -iter 10000 -pthr ${pth1} ${pth2} ${pth3} ${pth4} \
  -prefix AlphaSim_${var}_C

# array=($(1dsum all_ACF.txt))

# for item in "${array[@]}"
# do
#   ACF=$(ccalc ${item}/${subjectCount})
#   ACFs+=(${ACF})
# done

# echo ${ACFs[@]}

# # ACFa=`ccalc ${a[0]}/${subjectCount}`
# # ACFb=`ccalc ${a[1]}/${subjectCount}`
# # ACFc=`ccalc ${a[2]}/${subjectCount}`
# # ACFd=`ccalc ${a[3]}/${subjectCount}`
# # echo $ACF > avg-ACF.txt

# # # apath=${rtpath}/Alphasim


# 3dClustSim -mask ${GMMaskPath} -acf ${ACFs[0]} ${ACFs[1]} ${ACFs[2]} \
#   -iter 02440 -pthr ${pth1} ${pth2} ${pth3} ${pth4} \
#   -prefix  AlphaSim_rest_errt_C
