# MidTerm

- In the brain the activity of the neurons constantly fluctuates as
  you engage in different activities
- The brain has many specialized areas so that activities involving
  vision, hearing, touch, language, memory etc have different patterns
  of activity
- Even when you rest quietly with your eyes closed the brain is still
  highly active
- The patterns of activity in this resting state are though to reveal
  particular networks formed by particular areas of the brain that
  often act together.
- fMRI is a technique for measuring and mapping brain activity to
  those brain areas.
- To better understand the normal function of a healthy brain, and how
  that normal function gets disrupted in diseased condition.


## How MRI is done?

- Exploits the fact that the nucleus of a H atom behaves like a magnet
  when placed under strong magnetic fields. When we lay inside the
  strong magnetic field of an MR imaging system all of the H nuclei in
  our bodies (most of which are in water molecules) align with the
  direction of the external magnetic field. And when an RF pulse is
  applied (at an appropriate frequency), the H atoms absorb the RF
  energy which is quickly relinquished creating a faint MR signal for
  a brief time which can be detected by the RF coils.  An MR image is
  a visual representation of the distribution of the MR signal, by
  manipulating timing (phase) and frequency of the RF pulses.

## fMRI

- Normal NMR provides no insights on the brain function.
- However, when neural activity increases in a particular area of the
  brain, the MR signal also tends to increase (not by much) but just a
  little.
- fMRI is essentially a measure of this changes. Although the changes
  are not much significant they are still the basis for all of fMRI
  experiments done in the present day.


## Why fMR signal is sensitive to changes in brain activity?

fMR signal is not directly sensitive to the neural activity but rather
it is blood flow that follow the changes in the neural activity. It is
because oxygen-rich blood and oxygen-poor blood have different
magnetic properties. (Due to the nature of Hb that binds oxygen) If
blood is oxygenated, the MR signal is slightly stronger. Now the fact
that, Neural activity triggers a large change in blood flow and this
blood oxygenation level dependency (BOLD) is the basis for fMRI.

## Rationale

Structural MRI provides information about brain anatomy to complement
functional MRI in a number of ways. Since brain function depends on
the integrity of the brain structure, the underlying tissue integrity
allows one to examine the functional signals. Essentially, structural
MRI provides anatomical reference for visualization of activation
patterns and regions of interest to extract functional signal
information.

Information from structural MRI can be used to describe the shape,
size and integrity of gray matter, white matter and cerebrospinal
fluids in the brain.

Combining structural MRI and functional MRI can be a promising
technique to characterize normal and abnormal brain function which
will act as biomarkers for neurodegenerative or psychiatric disorders
to determine risk, progression and therapeutic effectiveness.

## Why its needed to separately pre process datasets for HCs and MDDs

1. To maintain integrity of group comparisons
2. Multi-collinearity
3. To avoid invalid analysis.

Covariate - a variable of quantitative nature such as age, the signals
produced by WM, CSF or GM.
