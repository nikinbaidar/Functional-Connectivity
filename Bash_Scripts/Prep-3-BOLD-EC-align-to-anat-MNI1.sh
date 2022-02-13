# in this script you will spatially normalize the anat data to MNI space
# and using the same transformation to normalize the BOLD data to MNI space
Subjects=$1
Root_dir=$2

for subject in ${Subjects}
do
cd ${Root_dir}/${subject}/T1

#---------adjust the input-files to the standard input-path---------
cp ../${subject}-BOLD-EC-base+orig*  ./
cp ../${subject}-BOLD-EC-volreg-mask+orig* ./
#-------------------------adjust end-------------------------

#########
# spatially normalize the anat data to MNI space
#########
# remove the skull of the anat data
rm -f ${subject}-anat-ns+orig*
rm BOLD-${subject}-EC-T1+orig*
3dUnifize -prefix BOLD-${subject}-EC-T1 -input BOLD-${subject}-EC-T1.nii
3dSkullStrip -input BOLD-${subject}-EC-T1+orig -prefix ${subject}-anat-ns
# roughly move the center of the base image of BOLD data with the anat data of each subject
# by default, _shft will be appended.
rm -f ${subject}-anat-ns_shft+* ${subject}-anat-ns_shft.1D
@Align_Centers -base ${subject}-BOLD-EC-base+orig -dset ${subject}-anat-ns+orig. -cm

# linearly align the anat data to BOLD data
# for epi option, we can take the whole functional iamge and specify -epi_base number,
# Also, we can take one subBrick and specify -epi_base as 0, cause there's only one subBrick.
rm -f ${subject}-anat-ns_shft_alBOLDEC+*
align_epi_anat.py -anat ${subject}-anat-ns_shft+orig -epi ${subject}-BOLD-EC-base+orig -epi_base 0  -master_anat ${subject}-anat-ns_shft+orig -anat2epi -suffix _alBOLDEC -anat_has_skull no -epi_strip 3dAutomask -volreg off -tshift off

# roughly move the center of the aligned anat data with stanard anat template in the MNI space
# the transformation information will be stored in the base image of BOLD data, too
# get ${subject}-BOLD-EC-base_shft+orig*
rm -f MNI_avg152T1+tlrc* ${subject}-anat-ns_shft_alBOLDEC_shft+orig* ${subject}-BOLD-EC-base_shft+orig*
ln -s /usr/local/AFNI/MNI_avg152T1+tlrc* ./
#rm -f ${subject}-anat-ns_shft_alBOLDEC_shft+* ${subject}-anat-ns_shft_alBOLDEC_shft.1D
@Align_Centers -base MNI_avg152T1+tlrc -dset ${subject}-anat-ns_shft_alBOLDEC+orig \
-child ${subject}-BOLD-EC-base+orig

rm ${subject}-T12T1_Allineate+orig*  ${subject}-T12T1_Allineate+tlrc* T12T1_Allineate.aff12.1D ${subject}-anat-ns_shft_alBOLDEC_shft+tlrc* anat-ns_shft_alBOLDEC_shft+tlrc* anat-ns_shft_alBOLDEC_shft_WARP*
3dAllineate -prefix ${subject}-T12T1_Allineate  -base MNI_avg152T1+tlrc -source ${subject}-anat-ns_shft_alBOLDEC_shft+orig -source_automask -cost lpa -1Dmatrix_save T12T1_Allineate.aff12.1D -autoweight -cmass
3dQwarp -blur 0 0 -base MNI_avg152T1+tlrc  -source ${subject}-T12T1_Allineate+tlrc  -prefix anat-ns_shft_alBOLDEC_shft
3dcopy anat-ns_shft_alBOLDEC_shft ${subject}-anat-ns_shft_alBOLDEC_shft

##########
## spatially normalize the BOLD data to MNI space
##########

# move the center of the 4D BOLD data roughly to the  space
# using the same parameters as the base iamge
rm -f${subject}-BOLD-EC-volreg-mask_temp+orig
3dcopy ${subject}-BOLD-EC-volreg-mask+orig ${subject}-BOLD-EC-volreg-mask_temp
#3drefit -duporigin ${subject}-BOLD-EC-base_shft+orig ${subject}-BOLD-EC-volreg-lp-dt_temp+orig
#rm -f ${subject}-BOLD-EC-volreg-lp-dt+orig*

rm ${subject}-BOLD-EC-volreg-mask_temp_shft+orig
@Align_Centers -base ${subject}-BOLD-EC-base_shft+orig  -dset ${subject}-BOLD-EC-volreg-mask_temp+orig -cm

## apply the nonlinear transformation and resample to 3x3x3 mm
rm ${subject}-BOLD-EC-volreg-Nwarp+orig* ${subject}-BOLD-EC-volreg-Nwarp+tlrc* ${subject}-BOLD-EC-volreg-Nwarp_Back+orig*
3dNwarpApply -master /home/rp/ADNI/script/mask/006_S_4150-BOLD-EC-volreg-Nwarp+tlrc -prefix ${subject}-BOLD-EC-volreg-Nwarp  -nwarp 'anat-ns_shft_alBOLDEC_shft_WARP+tlrc T12T1_Allineate.aff12.1D'  -source ${subject}-BOLD-EC-volreg-mask_temp_shft+orig
3dcopy ${subject}-BOLD-EC-volreg-Nwarp+orig ${subject}-BOLD-EC-volreg-Nwarp_Back
3drefit -view tlrc ${subject}-BOLD-EC-volreg-Nwarp+orig

##get tissuse-based signal before smooth
3dDeconvolve -input \
${subject}-BOLD-EC-volreg-Nwarp+tlrc \
-polort A -float -errts ${subject}-BeforeSmooth-ld -bucket BeforeSmooth-bucket

3dFourier -prefix ${subject}-BeforeSmooth-ld-bp \
-lowpass 0.08 -highpass 0.01 -ignore 0 -retrend ${subject}-BeforeSmooth-ld+tlrc


# spatial smoothing with 6 mm FWHM
# if you want
# you can modify the width of FWHM
rm -f ${subject}-BOLD-EC-volreg-Nwarp-blur6+tlrc*
3dmerge -doall -1blur_fwhm 6 -prefix ${subject}-BOLD-EC-volreg-Nwarp-blur6 \
${subject}-BOLD-EC-volreg-Nwarp+tlrc
#rm -f ${subject}-BOLD-EC-volreg-lp-dt_shft+tlrc*

# linear detrending
rm -f bucket* 3dDeconvolve.err ${subject}-BOLD-EC-volreg-Nwarp-blur6-ld+tlrc*
3dDeconvolve -input \
${subject}-BOLD-EC-volreg-Nwarp-blur6+tlrc \
-polort A -float -errts ${subject}-BOLD-EC-volreg-Nwarp-blur6-ld -bucket bucket

# temporal filtering band pass 0.01-0.1 Hz
# you can modify the filter if you you want
rm -f ${subject}-BOLD-EC-volreg-Nwarp-blur6-ld-bp+tlrc*
3dFourier -prefix ${subject}-BOLD-EC-volreg-Nwarp-blur6-ld-bp \
-lowpass 0.08 -highpass 0.01 -ignore 0 -retrend ${subject}-BOLD-EC-volreg-Nwarp-blur6-ld+tlrc

gzip *K
done
