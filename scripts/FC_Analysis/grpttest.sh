#!/bin/bash
ROI_Path="/home/nikin/projects/functional_connectivity/fc_analysis/roi_selection"
ROIs='r_rHipp r_cHipp l_vCa l_dCa'
GMMaskPath="/home/nikin/projects/functional_connectivity/fc_analysis/roi_selection/HC/ROI-0236/CommonGMmask+tlrc"
WORKING_DIRECTORY="/home/nikin/projects/functional_connectivity/fc_analysis/group_Ttest"

# Within group T-test
cd ${WORKING_DIRECTORY}/Intra/HC

for roi in ${ROIs}
do
 	rm -f HC_${roi}+tlrc*
	rm -f m_HC_${roi}+tlrc.*

	# one sample t-test for HC group 
	3dttest++ -prefix HC_${roi} -setA ${ROI_Path}/HC/ROI-0*/*_${roi}_z+tlrc.HEAD
	3dcalc -a HC_${roi}+tlrc -b ${GMMaskPath} -expr a*b -prefix m_HC_${roi}

done

cd ${WORKING_DIRECTORY}/Intra/MDD

for roi in ${ROIs}
do
	rm -f MDD_${roi}+tlrc*
	rm -f m_MDD_${roi}+tlrc.*
	#one sample t-test for MDD group
  3dttest++ -prefix MDD_${roi} -setA ${ROI_Path}/MDD/ROI-0*/*_${roi}_z+tlrc.HEAD
  3dcalc -a MDD_${roi}+tlrc -b ${GMMaskPath} -expr a*b -prefix m_MDD_${roi}
	
done

# Between group T-test
cd ${WORKING_DIRECTORY}/Inter/

for roi in ${ROIs}
do
	rm -f HC_vs_MDD_${roi}+tlrc.*
	rm -f m_HC_vs_MDD_${roi}+tlrc.*
	#group t test
  3dttest++ -prefix HC_vs_MDD_${roi} \
    -setA ${ROI_Path}/HC/ROI-0*/*_${roi}_z+tlrc.HEAD \
    -setB ${ROI_Path}/MDD/ROI-0*/*_${roi}_z+tlrc.HEAD

	3dcalc -a HC_vs_MDD_${roi}+tlrc -b ${GMMaskPath} \
    -expr a*b -prefix m_HC_vs_MDD_${roi}
done
