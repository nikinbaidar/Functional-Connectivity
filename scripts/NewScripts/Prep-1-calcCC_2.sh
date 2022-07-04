#!/bin/bash

#rtpath="/prot/MCI/Data/aMCI"
rtpath="/prot/MCI/Data/svMCI"
#rtpath="/prot/MCI/Data/NC"



#NC
#ARClist='sub101 sub102 sub104 sub105 sub106 sub107 sub109 sub111 sub112 sub117 sub120 sub121 sub126 sub127 sub132 sub133 sub134 sub139 sub141 sub142 sub143 sub145 sub146 sub147 sub149 sub150 sub155 sub156 sub157 sub159 sub161 sub163 sub168 sub169 sub170 sub171 sub173 sub176 sub177 sub181 sub182' 

#aMCI
#ARClist='sub204 sub208 sub215 sub225 sub229 sub237 sub240 sub252 sub256 sub261  sub264  sub271 sub202  sub205 sub210 sub212 sub216 sub226 sub235 sub244 sub249 sub253 sub257  sub262  sub266  sub272 sub203 sub207 sub213 sub220 sub227 sub236 sub239 sub247 sub248 sub251 sub254  sub260  sub263  sub270'

#svMCI
#ARClist=' sub01 sub04 sub03 sub05 sub06 sub08 sub09 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub19 sub21 sub22  sub25 sub26 sub29 sub30 sub31 sub32 sub33 sub35 sub36 sub37 sub38 sub39 sub41  sub43 sub44 sub45 sub46 sub48 sub51 sub50 sub53 sub55 sub56'

ARClist='sub29'
var=BOLD_volreg_lp_dt_shft-blur6; view=tlrc
var=rest_errt
Range='219 220 221 222 223 224 225 226 227 228 229 230'

ROIs='lvCa rvCa lGP rGP lNAC rNAC lvmPu rvmPu ldCa rdCa ldlPu rdlPu'


#************************************

for s in ${ARClist}
do
cd ${rtpath}/${s}
  #extract reference time courses from seed ROI
cnt=219
 for roi in ${ROIs}
 do
   echo $s $cnt $roi

rm -f ${s}_BNA_Atlas_Mask+tlrc.*

3dresample -master ${s}_${var}+tlrc -prefix ${s}_BNA_Atlas_Mask -input /prot/MCI/Data/BNA_MPM_thr25_1.25mm+tlrc
3dmaskave -mask ${s}_BNA_Atlas_Mask+tlrc -quiet -mrange ${cnt} ${cnt} ${s}_${var}+tlrc \
   > ${s}_${roi}.1D

    cnt=`echo "${cnt}+1"|bc`

    echo $s $roi
   rm -f ${s}_${roi}_cc3+tlrc.*
    rm -f ${s}_${roi}_z3+tlrc.*
   3dDeconvolve -input ${s}_${var}+tlrc \
     -mask /prot/MCI/Masks/CommonGMmask+tlrc \
     -jobs 8 -float \
     -GOFORIT 10 \
     -num_stimts 1 \
     -stim_file 1 ${s}_${roi}.1D \
     -stim_label 1 "${s}" \
     -tout -rout -bucket ${s}_buc
   3dcalc -a ${s}_buc+tlrc'[4]' -b ${s}_buc+tlrc'[2]' \
          -expr "ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)" -prefix ${s}_${roi}_cc3
# cc->Z-score transform using fisher's z-transform
 3dcalc -a ${s}_${roi}_cc3+tlrc -expr "0.5*log((1+a)/(1-a))" -datum float -prefix ${s}_${roi}_z3
    rm -f ${s}_buc+tlrc.*
    rm -f ${s}_${roi}.1D
  done
done
