



#input= rest_errt 
rtdir='/prot/VDMouse_FAHMU/Control'

#rtdir='/prot/VDMouse_FAHMU/VD_Model'

#Control 10 Rats
Rats='Control_01 Control_02 Control_03 Control_04 Control_05 Control_06 Control_07 Control_08 Control_09 Control_10'

###New_ROI_Bregma+orig.BRIK
### ROI_T2_Bregma+orig.BRIK

####ROI_Test+orig.BRIK


#VD Model 10 Rats Use 9
#Rats='VD_02 VD_04 VD_05 VD_06 VD_08 VD_13 VD_14 VD_15 VD_19' 

##Atlas_AR_110
## Rat template to use =brain.nii

#Range='87 88 109 110'

#ROIs='lNAcc rNAcc lStriatum rStriatum'

#ROIs='NAcc Striatum'

#ROIs='MCPu LCPu Acc'

#ROIs='leftMCPu leftLCPu leftAcc'

#ROIs='DCP VCP NAcc'

#ROIs='lDCP  rDCP lVCP rVCP lNAcc rNAcc'

#ROIs='lMPFC rMPFC lFrA rFrA lOFC rOFC'

ROIs='rMPFC'

var='rest_errt'  
    
for rat in ${Rats} # change the parameter in the bracket to your subject list
do
cd ${rtdir}/${rat}

##rm -f Atlas_AR_110_${rat}+orig.*

##3dresample -master ${rat}_${var}+orig -prefix Atlas_AR_110_${rat} -input /prot/VDMouse_FAHMU/Atlas/Atlas_AR_110+orig

for roi in ${ROIs}
  do
 
 if [ ${roi} = 'rMPFC' ]
    then 

3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 82 82 ${rat}_${var}+orig > ${rat}_${roi}.1D

fi

#for roi in ${ROIs}
#  do
# 
# if [ ${roi} = 'lMPFC' ]
#    then 
#          3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 81 81 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        
#        elif [ ${roi} = 'rMPFC' ]
#        then
#          3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 82 82 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        
#        elif [ ${roi} = 'lFrA' ]
#        then
#          3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 83 83 ${rat}_${var}+orig >  ${rat}_${roi}.1D
#        
#         elif [ ${roi} = 'rFrA' ]
#          then
#          3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 84 84 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        
#        elif [ ${roi} = 'lOFC' ]
#        then
#          3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 85 85 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'rOFC' ]
#        then
#          3dmaskave -mask  Atlas_AR_110_${rat}+orig -quiet -mrange 86 86 ${rat}_${var}+orig >  ${rat}_${roi}.1D
#       fi     
# 
## for rat in ${Rats} # change the parameter in the bracket to your subject list
##do
##cd ${rtdir}/${rat}
##3dresample -master ${rat}_${var}+orig -prefix ROI_test_${rat} -input /prot/VDMouse_FAHMU/Control/Control_01/ROI_test+orig
##
##for roi in ${ROIs}
##  do
## if [ ${roi} = 'lDCP' ]
##    then 
##          3dmaskave -mask  ROI_test_${rat}+orig -quiet -mrange 1 1 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        
##        elif [ ${roi} = 'lVCP' ]
##        then
##          3dmaskave -mask  ROI_test_${rat}+orig -quiet -mrange 3 3 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        
##        elif [ ${roi} = 'lNAcc' ]
##        then
##          3dmaskave -mask  ROI_test_${rat}+orig -quiet -mrange 5 5 ${rat}_${var}+orig >  ${rat}_${roi}.1D
##        
##         elif [ ${roi} = 'rDCP' ]
##          then
##          3dmaskave -mask  ROI_test_${rat}+orig -quiet -mrange 2 2 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        
##        elif [ ${roi} = 'rVCP' ]
##        then
##          3dmaskave -mask  ROI_test_${rat}+orig -quiet -mrange 4 4 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        elif [ ${roi} = 'rNAcc' ]
##        then
##          3dmaskave -mask  ROI_test_${rat}+orig -quiet -mrange 6 6 ${rat}_${var}+orig >  ${rat}_${roi}.1D
##       fi     

    rm ${rat}_buc
    rm -f ${rat}_${roi}_cc+orig.*
    rm -f ${rat}_${roi}_z+orig.*
   3dDeconvolve -input ${rat}_${var}+orig \
     -mask brainmask_bold_resample_${rat}+orig \
     -jobs 8 -float \
     -GOFORIT 10 \
     -num_stimts 1 \
     -stim_file 1 ${rat}_${roi}.1D \
     -stim_label 1 "${rat}" \
     -tout -rout -bucket ${rat}_buc
   3dcalc -a ${rat}_buc+orig'[4]' -b ${rat}_buc+orig'[2]' \
          -expr "ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)" -prefix ${rat}_${roi}_cc
# cc->Z-score transform using fisher's z-transform
 3dcalc -a ${rat}_${roi}_cc+orig -expr "0.5*log((1+a)/(1-a))" -datum float -prefix ${rat}_${roi}_z
    rm -f ${rat}_buc+orig.*
    rm -f ${rat}_${roi}.1D
    #((cnt++))
  done
done




############################################**********************************************************************************
# then 
#   3dmaskave -mask /prot/VDMouse_FAHMU/Atlas/ROI_Test+orig -quiet -mrange 1 2 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'VCP' ]
#        then
#          3dmaskave -mask /prot/VDMouse_FAHMU/Atlas/ROI_Test+orig -quiet -mrange 3 4 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'NAcc' ]
#        then
#          3dmaskave -mask /prot/VDMouse_FAHMU/Atlas/ROI_Test+orig -quiet -mrange 5 6 ${rat}_${var}+orig >  ${rat}_${roi}.1D
#       
#        fi
# 
# 
 #3dresample -master ${rat}_${var}+orig -prefix Left_Temp_Roi_${rat} -input /prot/VDMouse_FAHMU/Atlas/temp+orig
 # rm -f   Atlas_AR_110_${rat}+orig.*

#3dresample -master ${rat}_${var}+orig -prefix New_ROI_Bregma_${rat} -input /prot/VDMouse_FAHMU/Atlas/New_ROI_Bregma+orig   
    
#    for roi in ${ROIs}
#    do
#      echo $rat $roi $cnt
# #extract reference time courses from seed ROI
#
#   if [ ${roi} = 'DCP' ]
#        then 
#          3dmaskave -mask New_ROI_Bregma_${rat}+orig -quiet -mrange 1 2 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'VCP' ]
#        then
#          3dmaskave -mask New_ROI_Bregma_${rat}+orig -quiet -mrange 3 4 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'NAcc' ]
#        then
#          3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 5 6 ${rat}_${var}+orig >  ${rat}_${roi}.1D
#       
#        fi

#rm -f Test_Roi_${rat}+orig.*



###3dmaskave -mask Left_Test_Roi_${rat}+orig -quiet -mrange 1 1 ${rat}_${var}+orig > ${rat}_${roi}.1D
# 
# if [ ${roi} = 'leftMCPu' ]
#        then 
#          ##3dmaskave -mask /prot/VDMouse_FAHMU/Atlas/Test_Roi+orig -quiet -mrange 1 1 ${rat}_${var}+orig > ${rat}_${roi}.1D
#          3dmaskave -mask Left_Temp_Roi_${rat}+orig -quiet -mrange 1 1 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'leftLCPu' ]
#        then
#         3dmaskave -mask Left_Temp_Roi_${rat}+orig -quiet -mrange 2 2 ${rat}_${var}+orig > ${rat}_${roi}.1D
#        elif [ ${roi} = 'leftAcc' ]
#        then
#         3dmaskave -mask Left_Temp_Roi_${rat}+orig -quiet -mrange 3 3 ${rat}_${var}+orig >  ${rat}_${roi}.1D
#        
#        fi

##3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange ${cnt} ${cnt} ${rat}_${var}+orig > ${s}_${roi}.1D

    ##cnt=`echo "${cnt}+1"|bc`
    
#    if [ ${roi} = 'NAcc' ]
#      then 
#        3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 87 88 ${rat}_${var}+orig > ${rat}_${roi}.1D
#       elif [ ${roi} = 'Striatum' ]
#      then
#         3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 109 110 ${rat}_${var}+orig -savemask > ${rat}_${roi}.1D
#    
#fi
    ###echo $cnt $rat $roi



##################################*****************IT was for testing purposes only*****************


#ROIs='NAcc Striatum'
#
# var='tshift_rest_errt'  
#    
#for rat in ${Rats} # change the parameter in the bracket to your subject list
#do
#cd ${rtdir}
##cnt=0
#    for roi in ${ROIs}
#    do
#      echo $rat $roi $cnt
# #extract reference time courses from seed ROI
#
#  rm -f   Atlas_AR_110_${rat}+orig.*
#
#3dresample -master ${rat}_${var}+orig -prefix Atlas_AR_110_${rat} -input /prot/VDMouse_FAHMU/Atlas/Atlas_AR_110+orig
#
## if [ ${roi} = 'lNAcc' ]
##        then 
##          3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 87 87 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        elif [ ${roi} = 'rNAcc' ]
##        then
##          3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 88 88 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        elif [ ${roi} = 'lStriatum' ]
##        then
##          3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 109 109 ${rat}_${var}+orig >  ${rat}_${roi}.1D
##        elif [ ${roi} = 'rStriatum' ]
##        then
##          3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 110 110 ${rat}_${var}+orig > ${rat}_${roi}.1D
##        fi
#
###3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange ${cnt} ${cnt} ${rat}_${var}+orig > ${s}_${roi}.1D
#
#    ##cnt=`echo "${cnt}+1"|bc`
#    
#    if [ ${roi} = 'NAcc' ]
#      then 
#        3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 87 88 ${rat}_${var}+orig > ${rat}_${roi}.1D
#       elif [ ${roi} = 'Striatum' ]
#      then
#         3dmaskave -mask Atlas_AR_110_${rat}+orig -quiet -mrange 109 110 ${rat}_${var}+orig -savemask > ${rat}_${roi}.1D
#    
#fi
#    echo $cnt $rat $roi
#    rm ${rat}_buc
#    rm -f ${rat}_${roi}_cc_tshift+orig.*
#    rm -f ${rat}_${roi}_z_tshift+orig.*
#   3dDeconvolve -input ${rat}_${var}+orig \
#     -mask brainmask_bold_resample_${rat}+orig \
#     -jobs 8 -float \
#     -GOFORIT 10 \
#     -num_stimts 1 \
#     -stim_file 1 ${rat}_${roi}.1D \
#     -stim_label 1 "${rat}" \
#     -tout -rout -bucket ${rat}_buc
#   3dcalc -a ${rat}_buc+orig'[4]' -b ${rat}_buc+orig'[2]' \
#          -expr "ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)" -prefix ${rat}_${roi}_cc_tshift
## cc->Z-score transform using fisher's z-transform
# 3dcalc -a ${rat}_${roi}_cc+orig -expr "0.5*log((1+a)/(1-a))" -datum float -prefix ${rat}_${roi}_z_tshift
#    rm -f ${rat}_buc+orig.*
#    rm -f ${rat}_${roi}.1D
#    #((cnt++))
#  done
#done


