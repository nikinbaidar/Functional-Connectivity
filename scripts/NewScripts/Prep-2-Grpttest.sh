#!/bin/bash

#*****Parameters need to change******
#rtpath=/prot/MCI/Data/NC
#rtpath=/prot/MCI/Data/aMCI

rtpath=/prot/MCI/Data
rtdir=/prot/MCI

#gResult=${rtpath}/results/NDeg_9seeds
#zBackup=${rtpath}/zBackup/NDeg_9seeds
#mkdir -p ${gResult}; mkdir -p ${zBackup}
#mkdir -p ${rtpath}/group

#ROIs='rightVis leftVis rightVss leftVss rightDC leftDC rightDCP leftDCP rightDRP leftDRP rightVRP leftVRP rightaHipp leftaHipp rightpHipp leftpHipp'

#ROIs='rightVis leftVis rightDC leftDC'

ROIs='lvCa rvCa lGP rGP lNAC rNAC lvmPu rvmPu ldCa rdCa ldlPu rdlPu'


n=120; n_1=`echo $n-1 | bc`; nh=`echo $n/3 | bc`; nh_1=`echo $nh-1 | bc`

#mask=Mask-irg
#mask=Mask-irg_GMmask_4mm
#************************************

#Backup individual z-score

cd ${rtpath}/Grpttest
for roi in ${ROIs}
do
#  ${rtpath}/../scripts/ZBackup.sh $zBackup $roi
  rm -f NC_${roi}+tlrc.*
  rm -f aMCI_${roi}+tlrc.*
  rm -f svMCI_${roi}+tlrc.*
  

  #3dttest -session ${rtpath} -prefix NC_${roi} -base1 0 -set2 ${rtpath}/NC/*/sub*_${roi}_z+tlrc.HEAD 2
  3dttest++ -prefix NC_${roi} -setA ${rtpath}/NC/*/sub*_${roi}_z3+tlrc.HEAD
  3dttest++ -prefix aMCI_${roi} -setA ${rtpath}/aMCI/*/sub*_${roi}_z3+tlrc.HEAD
  3dttest++ -prefix svMCI_${roi} -setA ${rtpath}/svMCI/*/sub*_${roi}_z3+tlrc.HEAD  
  #3dttest -prefix aMCI_${roi} -base1 0 -set2 ${rtpath}/aMCI/sub*_${roi}_z+tlrc.HEAD 2> /dev/null
  #3dttest -prefix svMCI_${roi} -base1 0 -set2 ${rtpath}/svMCI/sub*_${roi}_z+tlrc.HEAD 2> /dev/null

  #3dttest -prefix UvN_${roi} -set1 ${zBackup}/N*_${roi}_z+tlrc.HEAD -set2 ${zBackup}/U*_${roi}_z+tlrc.HEAD 2> /dev/null
  rm -f m_NC_${roi}+tlrc.*
  rm -f m_aMCI_${roi}+tlrc.*
  rm -f m_svMCI_${roi}+tlrc.*
  
  3dcalc -a NC_${roi}+tlrc -b ${rtdir}/Masks/CommonGMmask+tlrc -expr a*b -prefix m_NC_${roi}
  3dcalc -a aMCI_${roi}+tlrc -b ${rtdir}/Masks/CommonGMmask+tlrc -expr a*b -prefix m_aMCI_${roi}
  3dcalc -a svMCI_${roi}+tlrc -b ${rtdir}/Masks/CommonGMmask+tlrc -expr a*b -prefix m_svMCI_${roi}
  #3dcalc -a UvN_${roi}+tlrc -b ${rtpath}/Common${mask}+tlrc -expr a*b -prefix mUvN_${roi}
done
#gzip *K

#ln -s $rtpath/Mean_anat_irg+tlrc.* .
