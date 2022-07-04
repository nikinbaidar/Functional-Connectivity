



#rtdir='/prot/VDMouse_FAHMU/Control'
#rtdir='/prot/VDMouse_FAHMU/VD_Model'
rtpath='/prot/VDMouse_FAHMU'

#Control
#Rats='Control_01 Control_02 Control_03 Control_04 Control_05 Control_06 Control_07 Control_08'

#Rats='Control_01'
#VD Model
#Rats='VD_02 VD_03 VD_05 VD_06 VD_08 VD_10 VD_13 VD_15 VD_19'  
#Rats='VD_13'


## Rat template to use =brain.nii
#Mask= brainmask_bold_resample_${rat}

#n=16; n_1=`echo $n-1 | bc`; nh=`echo $n/3 | bc`; nh_1=`echo $nh-1 | bc`

#ROIs='NAcc Striatum'

#ROIs='MCPu LCPu Acc'

#ROIs='lDCP  rDCP lVCP rVCP lNAcc rNAcc'
ROIs='lDCP lNAcc'

#dist=3.1; pth1=.001; dir1=001; dir2=02; vol=`ccalc -eval "3*3*3"`
#pth1=0.000005;
#a=`cdf -p2t fitt ${pth1} ${df}`; th1NC=${a##*=}
#a=`cdf -p2t fitt ${pth1} ${df}`; th1aMCI=${a##*=}
#a=`cdf -p2t fitt ${pth1} ${df}`; th1svMCI=${a##*=}

##th1NC=5.28;
##th1aMCI=5.28;

th1=2.27
th2=2.27

##echo $th1NC $th1aMCI $th1svMCI

#var=rest_errt

#********************************************

#####  Cluster Size read directly from AlphaSim directory

#cd ${rtpath}/Grpttest
#
#	clust1=`cat /prot/MCI/AlphaSim/AlphaSim_${var}_C_${pth1}.NN1_2sided.1D|grep 0.001|awk '{print $3}'`
#	Clust1=`ccalc -eval "${clust1[0]}"`
#	echo ${clust1[0]} ${Clust1}

cd ${rtpath}/Grpttest
for roi in ${ROIs}
do


  	#rm -f MC_Control_${roi}+orig.*
  	#rm -f MC_VD_${roi}+orig.*
  	
   #rm -f MAC_Control_${roi}+orig.*
  	#rm -f MAC_VD_${roi}+orig.
   
#rm -f Clust_mask+*
# 3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -1thresh ${th1} -dxyz=1 -savemask Clust_mask 1.01 148 M_Control_${roi}+orig
  
  3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -1thresh ${th1} -dxyz=1 -savemask M_${roi}_Clust_Mask 1.01 148 M_Control_${roi}+orig

#  3dcalc -a Clust_mask+orig -b M_Control_${roi}+orig -expr 'step(a)*b' -prefix MC_Control_${roi} 
#
# rm -f Clust_mask+*
# 3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -1thresh ${th2} -dxyz=1 -savemask Clust_mask 1.01 148 M_VD_${roi}+orig
#  
#  3dcalc -a Clust_mask+orig -b M_VD_${roi}+orig -expr 'step(a)*b' -prefix MC_VD_${roi} 
#  
#  
#  
#  rm -f Clust_mask+*
 #3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -1thresh ${th1} -dxyz=1 -savemask ${roi}_Clust_mask 1.01 148 MA_Control_${roi}+orig
  
  #3dcalc -a Clust_mask+orig -b MA_Control_${roi}+orig -expr 'step(a)*b' -prefix MAC_Control_${roi} 
#
# rm -f Clust_mask+*
# 3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -1thresh ${th2} -dxyz=1 -savemask Clust_mask 1.01 148 MA_VD_${roi}+orig
#  
#  3dcalc -a Clust_mask+orig -b MA_VD_${roi}+orig -expr 'step(a)*b' -prefix MAC_VD_${roi}
  
  done
  
  
  


	
#### generate mask based on the OR set of Normal & User Connectivity map




#cd ${rtpath}/Grpttest
#
#for roi in ${ROIs}
#
#do
# rm -f ${roi}-mask+orig.*

#  rm -f tmp${roi}cnt*
#  
#3dmerge -gcount -prefix tmp${roi}cnt MC_Control_${roi}+orig.HEAD MC_VD_${roi}+orig.HEAD 
#
# 3dcalc -a tmp${roi}cnt+orig -expr "ispositive(a)" -datum byte -prefix ${roi}-Mask
#

#3dmerge -gcount -prefix tmp1${roi}cnt MAC_Control_${roi}+orig.HEAD MAC_VD_${roi}+orig.HEAD 
#
#3dcalc -a tmp1${roi}cnt+orig -expr "ispositive(a)" -datum byte -prefix A_${roi}-Mask
 

# done

#
##rm tmp*

