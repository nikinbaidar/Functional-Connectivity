function seg(Path)
% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {Path};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});
