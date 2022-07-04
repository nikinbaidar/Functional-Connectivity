#*****Parameters need to change******


#AllSubjs="sub101 sub102 sub104 sub105 sub106 sub107 sub109 sub111 sub112 sub117 sub120 sub121 sub126 sub127 sub132 sub133 sub134 sub139 sub141 sub143 sub145 sub146 sub147 sub149 sub150 sub155 sub156 sub157 sub159 sub161 sub163 sub168 sub169 sub170 sub171 sub173 sub176 sub177 sub181 sub182
#sub202 sub203 sub204 sub205 sub207 sub208 sub210 sub212 sub213 sub215 sub216 sub220 sub225 sub226 sub227 sub229 sub235 sub236 sub237 sub239 sub240 sub244 sub247 sub248 sub249 sub251 sub252 sub253 sub254 sub256 sub257 sub260 sub261 sub262 sub263 sub264 sub266 sub270 sub271 sub272 sub01 sub04 sub03 sub05 sub06 sub08 sub09 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub19 sub21 sub22  sub25 sub26 sub29 sub30 sub31 sub32 sub33 sub35 sub36 sub37 sub38 sub39 sub41  sub43 sub44 sub45 sub46 sub48 sub51 sub50 sub53 sub55 sub56"



#AllSubjs='sub101 sub102 sub104 sub105 sub106 sub107 sub109 sub111 sub112 sub117 sub120 sub121 sub126 sub127 sub132 sub133 sub134 sub139 sub141 sub143 sub145 sub146 sub147  sub150 sub155 sub156 sub157 sub159 sub161 sub163 sub168 sub169 sub170 sub171 sub173 sub176 sub177 sub181 sub182 sub202  sub203 sub205  sub207  sub208  sub212  sub213  sub215 sub216 sub220 sub225 sub226 sub227 sub229 sub235 sub237 sub239 sub240 sub244 sub247 sub248 sub249 sub251 sub252 sub253 sub254 sub256 sub257 sub260 sub261 sub262 sub263 sub264 sub266 sub270 sub271 sub272 sub01 sub04 sub03 sub08 sub09 sub10 sub11  sub13 sub14  sub15 sub16 sub19 sub21 sub26 sub29 sub30 sub31 sub32  sub33 sub35 sub36 sub37 sub38 sub39 sub41  sub43 sub44 sub45 sub46 sub48 sub51 sub50 sub53'

AllSubjs="sub101 sub102 sub104 sub105 sub106 sub107 sub109 sub111 sub112 sub117 sub120 sub121 sub126 sub127 sub132 sub133 sub134 sub139 sub141 sub142 sub143 sub145 sub146 sub147 sub149 sub150 sub155 sub156 sub157 sub159 sub161 sub163 sub168 sub169 sub170 sub171 sub173 sub176 sub177 sub181 sub182 sub204 sub208 sub215 sub225 sub229 sub237 sub240 sub252 sub256 sub261  sub264  sub271 sub202  sub205 sub210 sub212 sub216 sub226 sub235 sub244 sub249 sub253 sub257  sub262  sub266  sub272 sub203 sub207 sub213 sub220 sub227 sub236 sub239 sub247 sub248 sub251 sub254  sub260  sub263  sub270 sub01 sub04 sub03 sub05 sub06 sub08 sub09 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub19 sub21 sub22  sub25 sub26 sub29 sub30 sub31 sub32 sub33 sub35 sub36 sub37 sub38 sub39 sub41  sub43 sub44 sub45 sub46 sub48 sub51 sub50 sub53 sub55 sub56"

SubNum=120
rtpath='/prot/MCI/Data'
var=rest_errt

#use edge neighbor with voxel size of 3x3x3mm
dist=4.3
#uncorrected p value
pth1=.001
#corrected p value
pc=.05

apath=${rtpath}/AlphaSim

#mkdir -p ${apath}
#************************************



### Estimate FWHM based on the epi data right before CC analysis ###
for sub in ${AllSubjs}
do
 cd ${rtpath}/fc
 	 
	3dFWHMx -dset ${sub}_${var}+tlrc -automask -detrend -unif -acf > ${sub}-acf.1D
  
done

#assume 20 subjects in the group, use average estimated FWHM
#as the input of alphasim

cd ${rtpath}/FWHM

ln -s -b -f /prot/MCI/Data/fc/*-acf.1D .

cat sub*-acf.1D  > all-ACF-temp.txt
cat all-ACF-temp.txt |awk 'NR%2==0' >all-ACF.txt
rm all-ACF-temp.txt

a=(`1dsum all-ACF.txt`)
ACFa=`ccalc ${a[0]}/${SubNum}`
ACFb=`ccalc ${a[1]}/${SubNum}`
ACFc=`ccalc ${a[2]}/${SubNum}`
ACF=`ccalc ${a[3]}/${SubNum}`
echo $ACF > avg-ACF.txt



## Calc cluster threshold for Connectivity map
## based on uncorrected p value, estimated FWHM,
## the mask where multiple comparison performed, and corrected p value
cd ${apath}

ln -s -b -f /prot/MCI/Masks/CommonGMmask+tlrc.* .

rm -f AlphaSim_${var}_C_${pth1}

3dClustSim -mask CommonGMmask+tlrc -acf ${ACFa} ${ACFb} ${ACFc} -iter 10000  -pthr ${pth1} -prefix  AlphaSim_${var}_C_${pth1}

