
rtpath='/prot/VDMouse_FAHMU'

#ROIs='NAcc Striatum'

# ROIs='MCPu LCPu Acc'
#ROIs='lNAcc rNAcc lStriatum rStriatum'


n=16; n_1=`echo $n-1 | bc`; nh=`echo $n/3 | bc`; nh_1=`echo $nh-1 | bc`


#ROIs='DCP VCP NAcc'


#ROIs='lDCP  rDCP lVCP rVCP lNAcc rNAcc'

#ROIs='lDCP lNAcc'

ROIs='lMPFC rMPFC lFrA rFrA lOFC rOFC'

###${roi}_Clust_mask

cd ${rtpath}/Grpttest

for roi in ${ROIs}

do

rm -f Control_vs_VD_${roi}+orig*


3dttest++ -prefix Control_vs_VD_${roi} -setA ${rtpath}/Control/*/*_${roi}_z+orig.HEAD -setB  ${rtpath}/VD_Model/*/*_${roi}_z+orig.HEAD
  

##3dcalc -a Control_vs_VD_${roi}+orig -b /prot/VDMouse_FAHMU/Atlas/Atlas_Mask_Resam+orig -expr a*b -prefix M_Control_vs_VD_${roi}

#***********************************************************************************





#rm -f M_Control_vs_VD_${roi}+orig*
#
#
#3dcalc -a Control_vs_VD_${roi}+orig -b ${roi}-Mask+orig -expr a*b -prefix M_Control_vs_VD_${roi}

##3dcalc -a Control_vs_VD_${roi}+orig -b ${roi}_Clust_mask+orig -expr a*b -prefix Mask_Control_vs_VD_${roi}

##M_${roi}_Clust_Mask

#3dcalc -a Control_vs_VD_${roi}+orig -b M_${roi}_Clust_Mask+orig -expr a*b -prefix BrainMask_Control_vs_VD_${roi}




done