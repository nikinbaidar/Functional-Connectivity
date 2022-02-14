# SPM

* Construction and assessment of spatially extended statistical
  processes used to test hypotheses about functional imaging data.

* SPM software package is designed for:

    - Analysis of brain imaging data sequences
    - The sequence can be a series of images from different cohorts
    - A cohort refers to a number of things or events standing or
      succeeding in order, and connected by a like relation.

## Some Insights

* The functional role played by any component of the brain is largely
  defined by its connections. Functional segregation demands that
  cells with common functional properties be grouped together.
  Segregation is the state of being separated from a mass.

* Functional localization implies that a function can be localized in
  a cortical are, where as functional specialization suggests that
  a cortical area is specialized for some aspects of perceptual or
  motor processing, and is anatomically segregated within the cortex.

## Introduction to Statistical Parametric Mapping

The material presented in this section provides sufficient background
to understand the principles of experimental design and data analysis
tools.

Analysis involves identifying and making inference about regionally
specific effects in the brain. *Statistical parametric mapping* is
generally used to identify functionally specialized brain responses
and is the most prevalent approach to characterize functional
connectivity. It is a voxel-based approach, employing classical
inference, to make some inference about regionally specific responses
to experimental factors. For an observed response to be assigned to
a particular brain structure, or a cortical area, the data must be
confirmed to be from a known anatomical space. Mapping creates
a statistical model but before that, it is important to realign
a time-series of images. The general ideas behind statistical
parametric mapping are then described an illustrated with attention to
the different sorts of inferences that can be made with different
experimental factors.

- Linear time invariant models - bridges the gap between inferential
  models employed by statistical mapping and conventional signal
  processing approaches.
- Non-linear time variant models - indicate when the assumptions
  behind the linear models are violated.

The analysis of functional neuroimaging data involves many steps that
can be broadly divided into:

1. Spatial processing.
2. Estimating the parameters of a statistical model.
3. Making inferences about those parameter estimates with appropriate
   statistics.

## Spatial Processing: Realignment & Normalization

Spatial processing is to combine data from different scans from the
same subject so that they conform to the same anatomical
frame. Spatial processing reduces unwanted variance components in the
voxel time-series that are induced by movement or shape differences
among a series of scans. Voxel-based analyses assume that the data
from a particular voxel all derive from the same part of the
brain. Violations of this assumption will introduce artifactual
changes in the voxel values.

The first step is to realign, i.e. to "undo" the effects of subject
movement during the scanning session. After realignment, the data can
then be transformed using linear and non-linear deviations into
a standard anatomical space.

### Realignment

Changes in signal intensity over time, from any one voxel may arise
from head motion. This can lead to misinterpretations (particularly in
fMRI studies). Even co-operative subjects show displacements up to
several millimeters. Realignment involves minimizing the differences
between each successive scan and a reference scan viz. the average of
all scans in the time series. The data is transformed by re-sampling
the data using trilinear, sinc or spline interpolation.

### Normalization

After realigning the data, a mean image of the series can be used to
estimate some warping parameters that maps it onto a template that
already conforms to some standard anatomical space.

## Estimating Parameters of Statistical Model

This estimation can use a variety of parameters to create
a statistical model for mapping (a functional response to an
anatomical area). The parameters constitute a spatial transformation
matrix.

Estimation of parameters can be accommodated in a simple Bayesian
framework, where a deformation parameter, θ is calculated. The
deformation parameter 'θ' has a max posterior probability p(θ|y) for
a given data 'y'. Put simply, we need to find the deformation that is
most likely for a given data. This can be simply done using the Bayes
theorem. The probability of the deformation parameter is taken as
a difference between the index image and the best linear combination
of templates depicting gray matter, white matter, CSF and skull tissue
partitions.

## Statistical Parametric Mapping

Statistical parametric mapping entails the construction of spatially
extended statistical processes to test hypotheses about regionally
specific effects. Statistical parametric maps (SPMs) are image
processes with voxel values that are distributed according to a known
probability density function. SPM involves one analyses for each and
every voxel using standard (univariate) statistical test. The
resulting statistical parameters are assembled into an image i.e. the
SPM.

