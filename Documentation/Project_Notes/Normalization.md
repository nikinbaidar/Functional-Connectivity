# Normalization

## Step 1 : `3dUnifize`

* The input dataset is a T1-weighted anatomical image.
* It is useful to run this program to take before `3dSkullStrip`,
  because the latter program can fail if the input volume is strongly
  shaded
* `3dUnifize` will mostly remove such shading artifacts.
* The output dataset was set in the talairach space. Talairach
  coordinates is a 3-dimensional coordinate system of the human brain,
  which is used to map the location of brain structures independent
  from individual differences in the size and overall shape of the
  brain.

## Step 3: `@Align_Centers`

* Move the center of the anatomical image to the center of the base
  fMRI data.
* By default, center is the center of the volume's grid.
* Center is the center of mass of the volume when `-cm` flag is on.
* This appends "_shft" to the current filename.
* The overwrite warning you get can be avoided with `-no_cp` option

## Step 4: `align_epi_anat`

* Compute the alignment between two datasets, an EPI (Echo Planner
  Image) and an anatomical/structural dataset.
* Then, apply the resulting transformation to one or the other to
  bring them into alignment. By default, the script always aligns the
  anatomical dataset to the EPI dataset and the resulting
  transformation is saved to a 1D file. Two types of transformations
  can be achieved with:

    - `-anat2epi` (default)
    - `-epi2anat`

* `-epi_strip` flag allows specification of a method to mask brain in
  the EPI data.
* `-volreg [on]/off` sets a flag to perform volume registration on EPI
  dataset before alignment.
* `-tshift [on]/off` sets a flag to perform time shift on EPI
  dataset before alignment.
* `-master_anat` specifies the master grid resolution for aligned
  anatomical data output. The default for `master_anat` is the source.
  So can be skipped if a different dataset is not being used.
* `resample [on]/off` Allow resampling or not.

## Step 5: `@Align_centers`

A second alignment of centers is necessary to roughly move the center
of the aligned anatomical dataset with the standard anatomical
template in the MNI space. The MNI space template should've been
downloaded during AFNI installation.

Run `afni_system_check.py -check_all | grep atlas` to figure where the
default templates are lurking (if they are even installed).

> If the atlases are not found, you can download a tarball from [here](https://bit.ly/3BpKN2K).
> After the tarball has been extracted, you can simply place them into
> whichever location `afni` binaries are stored (run `which afni`).



