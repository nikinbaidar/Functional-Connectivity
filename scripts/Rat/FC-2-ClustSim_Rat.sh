

rtpath='/prot/VDMouse_FAHMU'

###Control 10 Rats
#Rats='Control_01 Control_02 Control_03 Control_04 Control_05 Control_06 Control_07 Control_08 Control_09 Control_10'

###Rats='Control_01'

####VD Model 10 Rats Use 9
#Rats='VD_02 VD_04 VD_05 VD_06 VD_08 VD_13 VD_14 VD_15 VD_19' 
#mkdir -p /prot/VDMouse_FAHMU/fc

#for rat in ${Rats}
#do
#  cd ${rtpath}
#  cp -f /prot/VDMouse_FAHMU/Control/${rat}/${rat}_rest_errt+orig.BRIK ./fc
#  cp -f /prot/VDMouse_FAHMU/Control/${rat}/${rat}_rest_errt+orig.HEAD ./fc
#  cp -f /prot/VDMouse_FAHMU/Control/${rat}/${rat}_rest_errt+orig.BRIK.gz ./fc
#done
#
#for rat in ${Rats}
#do
#  cd ${rtpath}
#  #cp -f /prot/VDMouse_FAHMU/VD_Model/${rat}/${rat}_rest_errt+orig.BRIK ./fc
#  cp -f /prot/VDMouse_FAHMU/VD_Model/${rat}/${rat}_rest_errt+orig.HEAD ./fc
#  cp -f /prot/VDMouse_FAHMU/VD_Model/${rat}/${rat}_rest_errt+orig.BRIK.gz ./fc
#done


##*************************************************************************************


#Control=8;Vascular Dementia=9 
#NCvsDementia


#rtdir='/prot/VDMouse_FAHMU/Control'
#rtdir='/prot/VDMouse_FAHMU/VD_Model'

#Control 10 Rats
#Rats='Control_01 Control_02 Control_03 Control_04 Control_05 Control_06 Control_07 Control_08 Control_09 Control_10'

#Rats='Control_01'

#VD Model 10 Rats Use 9
#Rats='VD_02 VD_04 VD_05 VD_06 VD_08 VD_13 VD_14 VD_15 VD_19' 

##use edge neighbor with voxel size of 3x3x3mm
#uncorrected p value

SubNum=19
pth1=.001
pth2=.005
pth3=.01
pth4=.05
##corrected p value
pc=.05
#

#
##rm -rf ${apath} 
##mkdir -p ${apath}
#
#
##3dcopy ${MaskDir}/brainmask_anat.nii ${MaskDir}/brainmask_anat
#
#
#
##************************************
#

#MaskDir='/prot/VDMouse_FAHMU/Atlas'
rtdir='/prot/VDMouse_FAHMU'
var=rest_errt
apath=${rtdir}/AlphaSim

#AllRats="Control_01 Control_02 Control_03 Control_04 Control_05 Control_06 Control_07 Control_08 Control_09 Control_10 VD_02 VD_04 VD_05 VD_06 VD_08 VD_13 VD_14 VD_15 VD_19"
#
#### Estimate FWHM based on the epi data right before CC analysis ###
#### 3dFWHMx:Estimating and using noise smoothness values
#
#3dresample -master ${rtdir}/fc/Control_01_rest_errt+orig  -prefix ${rtdir}/fc/Atlas_Mask_Resam  -input $MaskDir/Atlas_Mask+orig -prefix Atlas_Mask_Resam 
##cp -f Atlas_Mask_Resam+orig  ${rtdir}/fc

##${roi}_Clust_mask

ROIs='lDCP lNAcc'

#for rat in ${AllRats}
#do
# cd ${rtdir}/fc
# 	 rm 3dFWHMx.1D* 
#	3dFWHMx -dset ${rat}_${var}+orig -mask  Atlas_Mask_Resam+orig -detrend -unif -acf > ${rat}-acf.1D
#  mv ${rat}-acf.1D ${apath}
#done
#
#
###use average estimated FWHM in the group
###as the input of alphasim
cd ${apath}

cat *-acf.1D  > all-ACF-temp.txt
cat all-ACF-temp.txt |awk 'NR%2==0' >all-ACF.txt
rm all-ACF-temp.txt

a=(`1dsum all-ACF.txt`)
ACFa=`ccalc ${a[0]}/${SubNum}`
ACFb=`ccalc ${a[1]}/${SubNum}`
ACFc=`ccalc ${a[2]}/${SubNum}`
ACF=`ccalc ${a[3]}/${SubNum}`
echo $ACF > avg-ACF.txt
##
#### Calc cluster threshold for Connectivity map
#### based on uncorrected p value, estimated FWHM,
#### the mask where multiple comparison performed, and corrected p value
##
##rm -f AlphaSim_${var}_C
#
#3dClustSim -mask $MaskDir/Atlas_Mask+orig -acf ${ACFa} ${ACFb} ${ACFc} -iter 10000  -pthr ${pth1} ${pth2} ${pth3} ${pth4} -prefix  AlphaSim_${var}_A
#
##3dClustSim -mask $MaskDir/brainmask_bold+orig -acf ${ACFa} ${ACFb} ${ACFc} -iter 10000  -pthr ${pth1} ${pth2} ${pth3} ${pth4} -prefix  AlphaSim_${var}_B   

###3dClustSim -mask /prot/VDMouse_FAHMU/fc/Atlas_Mask_Resam+orig -acf ${ACFa} ${ACFb} ${ACFc} -iter 10000  -pthr ${pth1} ${pth2} ${pth3} ${pth4} -prefix  AlphaSim_${var}_AResamp

for roi in ${ROIs}
do

3dClustSim -mask ${rtdir}/Grpttest/${roi}_Clust_mask+orig -acf ${ACFa} ${ACFb} ${ACFc} -iter 10000  -pthr ${pth1} ${pth2} ${pth3} ${pth4} -prefix  AlphaSim_${var}_${roi}   


done







