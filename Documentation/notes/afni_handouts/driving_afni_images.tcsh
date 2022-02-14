#!/bin/tcsh

# See more examples here:
# https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/tutorials/auto_image/main_toc.html

# =========================================================================
#
# For each example below, you can use the "afni image viewer" command
# that is put in the a comment following the image-generating example
# to view the results.
#
# You can also view the image with whatever program suits your
# computer.  On Linux, that might be "eog IMAGE_NAME".  On Mac, that
# might be just "open IMAGE_NAME".
#
# These commands are meant to be run in your Bootcamp data directory
# called "AFNI_data6/afni/".  By default installation, that branch
# would be sitting in your "home" on your computer.  If you want, you
# can edit this "topdir" variable to be wherever else you unpacked
# your data.

set topdir = $HOME
cd ${topdir}/AFNI_data6/afni

# =========================================================================

# ---- @snapshot_volreg example: quick check of alignment with edges -----

# 0) Check alignment between dsets of making an "edge-ified" version
#    of one and overlaying it.  Also highlights extends/coverage of
#    dsets.  Output is a montage of all three viewplanes.
@snapshot_volreg                            \
    anat+orig                               \
    epi_r1+orig                             \
    sv.00.edgy
# aiv ./sv.00.edgy.jpg

# =========================================================================

# ------ @chauffeur_afni examples: drive afni to save imgs/montages -------

# 0) Check EPI alignment/coverage with anat (NB: this is before using
#    alignment tool).  Output comes in sets of 3: one for each viewplane.
@chauffeur_afni                             \
    -ulay  anat+orig                        \
    -olay  mask.auto.nii.gz                 \
    -prefix   ./ch.00.anat_mask             \
    -save_ftype JPEG                        \
    -opacity 4                              \
    -montx 3 -monty 3                       \
    -set_xhairs OFF                         \
    -label_mode 1 -label_size 3             \
    -do_clean
# aiv ./ch.00.anat_mask*jpg

# 1) Check out stats results: view beta coefficient but threshold
#    based on stats values. Also, "focus" on just slices where overlay
#    has data, so as not to waste space
@chauffeur_afni                             \
    -ulay  anat+orig                        \
    -olay  func_slim+orig                   \
    -box_focus_slices AMASK_FOCUS_OLAY      \
    -set_subbricks -1 3 4                   \
    -cbar Reds_and_Blues_Inv                \
    -func_range      3                      \
    -thr_olay        3.1234                 \
    -opacity 7                              \
    -prefix   ./ch.01.anat_stat_ok          \
    -save_ftype JPEG                        \
    -montx 5 -monty 1                       \
    -set_xhairs OFF                         \
    -label_mode 1 -label_size 3             \
    -do_clean
# aiv ./ch.01.anat_stat_ok*jpg

# 2) Same as previous example, *but* use an internal p-to-stat
#    conversion to calculate stat value for threshold, *and* don't
#    just threshold and hide data- allow sub-threshold values to be
#    seen, just fading increasingly transparent as their values are
#    further below chosen threshold.  Also, save the cbar and relevant
#    values to file.
@chauffeur_afni                             \
    -ulay  anat+orig                        \
    -olay  func_slim+orig                   \
    -box_focus_slices AMASK_FOCUS_OLAY      \
    -set_subbricks -1 3 4                   \
    -cbar Reds_and_Blues_Inv                \
    -func_range      3                      \
    -thr_olay_p2stat 0.001                  \
    -thr_olay_pside  bisided                \
    -olay_alpha      Yes                    \
    -olay_boxed      Yes                    \
    -opacity 7                              \
    -pbar_saveim  ./ch.02.anat_stat_better_cbar.jpg \
    -prefix       ./ch.02.anat_stat_better  \
    -save_ftype JPEG                        \
    -montx 5 -monty 1                       \
    -set_xhairs OFF                         \
    -label_mode 1 -label_size 3             \
    -do_clean
# aiv ./ch.02.anat_stat_better*jpg

# =========================================================================

# ---------------- imcat examples: glue imgs together ----------------

# 0) Combine the two stats images from above for a visually paired
#    comparison.
imcat                                    \
    -echo_edu                            \
    -gap 5                               \
    -gap_col 254 66 184                  \
    -nx 1                                \
    -ny 2                                \
    -prefix ./imc.00.combo_stat_sag.jpg  \
    ./ch.0?.anat_stat_*sag*jpg
# aiv ./imc.00.combo_stat_sag.jpg

# 1) Combine all the outputs of the 'better' stats for comprehensive
#    view.
imcat                                    \
    -echo_edu                            \
    -gap 5                               \
    -gap_col 200 200 200                 \
    -nx 1                                \
    -ny 3                                \
    -prefix ./imc.01.all_stat_better.jpg \
    ./ch.02.anat_stat_better.*.jpg
# aiv ./imc.01.all_stat_better.jpg


