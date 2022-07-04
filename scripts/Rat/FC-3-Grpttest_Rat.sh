
#!/bin/bash

#input= rest_errt 
#rtdir='/prot/VDMouse_FAHMU/Control'

rtdir='/prot/VDMouse_FAHMU/VD_Model'

rtpath='/prot/VDMouse_FAHMU'

#Control
Rats='Control_01 Control_02 Control_03 Control_04 Control_05 Control_06 Control_07 Control_08 Control_09 Control_10'

##Control_05
#Rats='Control_01'
#VD Model
#VD Model 10 Rats Use 9
#Rats='VD_02 VD_04 VD_05 VD_06 VD_08 VD_13 VD_14 VD_15 VD_19' 

## Rat template to use =brain.nii
#Mask= brainmask_bold_resample_${rat}

#n=16; n_1=`echo $n-1 | bc`; nh=`echo $n/3 | bc`; nh_1=`echo $nh-1 | bc`

#ROIs='NAcc Striatum'
#ROIs='lNAcc rNAcc lStriatum rStriatum'

#ROIs='MCPu LCPu Acc'
#mkdir -p ${rtpath}/Grpttest
    

#Backup individual z-score

## ROIs='DCP VCP NAcc'

#ROIs='lDCP  rDCP lVCP rVCP lNAcc rNAcc'

ROIs='lMPFC rMPFC lFrA rFrA lOFC rOFC'

cd ${rtpath}/Grpttest

#3dresample -master VD_DCP+orig -prefix brainmask_bold_resample_VD -input ${rtpath}/Atlas/brainmask_bold+orig
#3dresample -master Control_DCP+orig -prefix brainmask_bold_resample_Control -input ${rtpath}/Atlas/brainmask_bold+orig

#3dresample -master VD_lDCP+orig -prefix Atlas_Mask_VD -input ${rtpath}/Atlas/Atlas_Mask+orig
#3dresample -master Control_lDCP+orig -prefix Atlas_Mask_Control -input ${rtpath}/Atlas/Atlas_Mask+orig

for roi in ${ROIs}
do
#  ${rtpath}/../scripts/ZBackup.sh $zBackup $roi
  rm -f Control_${roi}+orig.*
  rm -f VD_${roi}+orig.*
#  
# 
 3dttest++ -prefix Control_${roi} -setA ${rtpath}/Control/*/*_${roi}_z+orig.HEAD
 3dttest++ -prefix VD_${roi} -setA ${rtpath}/VD_Model/*/*_${roi}_z+orig.HEAD
#    
done   
  #rm -f M_Control_${roi}+orig.*
  #rm -f M_VD_${roi}+orig.*
  
#  rm -f MA_Control_${roi}+orig.*
#  rm -f MA_VD_${roi}+orig.*

#3dresample -master Control_${roi}+orig -prefix brainmask_bold_resample_Control_${roi} -input ${rtpath}/Atlas/brainmask_bold+orig
  
#3dcalc -a ${rtpath}/Grpttest/Control_${roi}+orig -b ${rtpath}/Grpttest/brainmask_bold_resample_Control+orig -expr a*b -prefix ${rtpath}/Grpttest/M_Control_${roi}+orig



#3dcalc -a ${rtpath}/Grpttest/Control_${roi}+orig -b Atlas_Mask_Control+orig -expr a*b -prefix ${rtpath}/Grpttest/MA_Control_${roi}+orig

#####3dcopy ${rtpath}/Atlas/brainmask_bold.nii ${rtpath}/Atlas/brainmask_bold


#3dresample -master VD_${roi}+orig -prefix brainmask_bold_resample_VD_${roi} -input ${rtpath}/Atlas/brainmask_bold+orig



#3dcalc -a ${rtpath}/Grpttest/VD_${roi}+orig -b Atlas_Mask_VD+orig -expr a*b -prefix ${rtpath}/Grpttest/MA_VD_${roi}+orig

#3dcalc -a ${rtpath}/Grpttest/VD_${roi}+orig -b brainmask_bold_resample_VD+orig -expr a*b -prefix ${rtpath}/Grpttest/M_VD_${roi}+orig

#3dcalc -a ${rtpath}/Grpttest/VD_${roi}+orig -b brainmask_bold_resample_VD_${roi}+orig -expr a*b -prefix ${rtpath}/Grpttest/M_VD_${roi}+orig


#done 
#gzip *K


