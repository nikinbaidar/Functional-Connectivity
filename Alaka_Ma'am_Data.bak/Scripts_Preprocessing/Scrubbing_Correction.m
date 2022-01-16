function Scrubbing_Correction(SubjectPath,SubjectID)
%script for correction of microHeadMotion which can't be removed with traditional 
%head motion correction methods.
warning('off')
%%%%%%%%%%%%%%%%%%%parameters to set before running%%%%%%%%%%%%%%%%%%%%%%%%%
%parameters recommended by the original article: FD_threshold=0.5;Motion_thres=1.5; PreviousPoints=1; LaterPoints=2; LeastTRs=128.
%but we can adjust according to our own data
remove_marker=0 %if the subject need to be removed
FD_thres=0.7 %threshold for FD between continuous frames, and should be adjusted with frameRemained.mat, which shouldn't
             %have so much subjects if we have limited number of subjects.
Motion_thres=1.5 %threshold for Motion of one subject across TRs eg: 1.5mm
RotationTransition_thres=2 %threshold for rotation and transition of one subject eg: 2 mm and 2 degree
PreviousPoints=1 %to accommodate smoothing, to check 1 back from the marked frame
LaterPoints=2 %also, check 2 forward from the marked frame
LeastTRs=100 %to ensure adequate power for the following analysis, time Points should be gauranteed.
             %actually, the requirement is no less than 5 min, since our TR=3s, then there should be no less than 100 TRs
%%%%%%%%%%%%%%%%%%%%%%%%       Setting end        %%%%%%%%%%%%%%%%%%%%%%%%%% 
! rm Scrubbed*
! rm TemporalMask.mat
! rm FD_EachFrame.mat

%this should be saved in the outer space of the subject specific folder, cause it's across-subject file.
load /home/rp/ADNI/script/deleteSubjects.mat
load /home/rp/ADNI/script/lessthanLeastTRs.mat
load /home/rp/ADNI/script/allRemovedSubjects.mat
load /home/rp/ADNI/script/framesRemained.mat

%read alignment parameters file coming from 3dvolreg(traditional head motion correction method)
cd(SubjectPath);
parametersFile=[SubjectID,'-BOLD-EC-motion.1D'];

%calculate FD(Framewise Displacement) power
align_parameter=load(parametersFile);
FDDiff=diff(align_parameter);
%since diff defined as line(i)-line(i-1), we should fill up the first line manually.
FDDiff=[zeros(1,6);FDDiff];
FDDiff_Distance=FDDiff;
%convert rotation parameters from degree to distances
FDDiff_Distance(:,4:6)=FDDiff_Distance(:,4:6)*50*pi/180;
FD_EachFrame=sum(abs(FDDiff_Distance),2);
save('FD_EachFrame.mat','FD_EachFrame');

%Estimate data quality in movements
XMotion=abs(align_parameter(:,1));
YMotion=abs(align_parameter(:,2));
ZMotion=abs(align_parameter(:,3));
XRotation=abs(align_parameter(:,4));
YRotation=abs(align_parameter(:,5));
ZRotation=abs(align_parameter(:,6));
RMSParameter=rms(align_parameter(:,1:6),2);

%if the max transition of any direction of x,y,z excess RotationTransition_thres, then the subject should be removed.
%also, if the max rotation of any direction excess RotationTransition_thres, then the subject should be removed.
%besides, if max value of RMS of six parameters excess Motion_thres, then the subject should be removed.
if any(XMotion>2) || any(YMotion>2) || any(ZMotion>2) || any(XRotation>2) || any(YRotation>2) || any(ZRotation>2) || any(RMSParameter>1.5) 
    deleteSubjects{size(deleteSubjects,1)+1,1}=SubjectID;
    deleteSubjects{size(deleteSubjects,1),2}=any(XMotion>2);
    deleteSubjects{size(deleteSubjects,1),3}=any(YMotion>2);
    deleteSubjects{size(deleteSubjects,1),4}=any(ZMotion>2);
    deleteSubjects{size(deleteSubjects,1),5}=any(XRotation>2);
    deleteSubjects{size(deleteSubjects,1),6}=any(YRotation>2);
    deleteSubjects{size(deleteSubjects,1),7}=any(ZRotation>2);
    deleteSubjects{size(deleteSubjects,1),8}=any(RMSParameter>1.5);
    deleteSubjects{size(deleteSubjects,1),9}=SubjectPath;
    remove_marker=1;
    save('/home/rp/ADNI/script/deleteSubjects.mat','deleteSubjects');
end


if remove_marker==0
	%Generate temporal mask, actually, we should also calculate DVARS, and mark the frame satisfies:
	%1.
	%2.
	%however, cause it's not quite clear for the details for DVARS, we just use FD, which means it's more strict.
	load('FD_EachFrame.mat');
	FD=FD_EachFrame;
	TemporalMask=ones(length(FD),1);
	Index=find(FD>FD_thres);
	TemporalMask(Index)=0;

	%also marking the frames 1 back from marked frames
	IndexPrevious=Index;
	for i=1:PreviousPoints
	    IndexPrevious=IndexPrevious-1;
	    IndexPrevious=IndexPrevious(IndexPrevious>=1);
	    TemporalMask(IndexPrevious)=0;
	end

	%also marking the frames 2 forward from marked frames
	%the subscript in matlab begins from 1, not 0
	IndexNext=Index;
	for i=1:LaterPoints
	    IndexNext=IndexNext+1;
	    IndexNext=IndexNext(IndexNext<=length(FD));
	    TemporalMask(IndexNext)=0;
	end
	save('TemporalMask.mat','TemporalMask');

	%read 4D final output from traditional pre_processing
	traditionalFile=[SubjectID,'_rest_errt+tlrc'];
	[err AllVolume Info errmeg]=BrikLoad(traditionalFile);
	[Dim1,Dim2,Dim3,nTimePoints]=size(AllVolume);
	AllVolume=reshape(AllVolume,[],nTimePoints)';

	%to remove those frames with unsatisfied FD 
	if any(TemporalMask)
	    AllVolume=AllVolume(find(TemporalMask),:);
	    newTimePoints=size(AllVolume,1);
	    if newTimePoints>=LeastTRs
		    %save the original Number of frames and the frames remained after scrubbing.
		    framesRemained{1,size(framesRemained,2)+1}=newTimePoints;
		    framesRemained{2,size(framesRemained,2)}=nTimePoints;
		    framesRemained{3,size(framesRemained,2)}=SubjectPath;
		    save('/home/rp/ADNI/script/framesRemained.mat','framesRemained');
            end
	else
	    allRemovedSubjects{size(allRemovedSubjects,1)+1,1}=SubjectID;
            allRemovedSubjects{size(allRemovedSubjects,1),2}=SubjectPath;
	    save('/home/rp/ADNI/script/allRemovedSubjects.mat','allRemovedSubjects');
	    return
	end

	AllVolume=reshape(AllVolume',[Dim1,Dim2,Dim3,newTimePoints]);
	%the remaining frames should be no less than 100
	if newTimePoints>=LeastTRs
	    %write to 4D tlrc file, change their value range and all the attributes related to time points.
	    Info.BRICK_STATS=[min(AllVolume(:)),max(AllVolume(:))];
	    Info.BRICK_TYPES=Info.BRICK_TYPES(:,find(TemporalMask));
            Info.TAXIS_NUMS(1)=newTimePoints;
	    Info.DATASET_RANK=[3,newTimePoints];
	    Info.BRICK_FLOAT_FACS=Info.BRICK_FLOAT_FACS(:,find(TemporalMask));
	    Index_SubBRIK=regexp(Info.BRICK_LABS, '~', 'split');
            newIndex_SubBRIK=Index_SubBRIK(find(TemporalMask));
	    Info.BRICK_LABS=strjoin(newIndex_SubBRIK,'~');
	    Opt.Prefix=['Scrubbed_',SubjectID,'_rest_errt'];
	    Opt.View='tlrc';
	    Opt.OverWrite='y';
	    [err,errmeg,Info]=WriteBrik(AllVolume,Info,Opt);
	else
	    lessthanLeastTRs{size(lessthanLeastTRs,1)+1,1}=SubjectID;
            lessthanLeastTRs{size(lessthanLeastTRs,1),2}=nTimePoints;
            lessthanLeastTRs{size(lessthanLeastTRs,1),3}=newTimePoints;
	    lessthanLeastTRs{size(lessthanLeastTRs,1),4}=SubjectPath;
	    save('/home/rp/ADNI/script/lessthanLeastTRs.mat','lessthanLeastTRs');
	end

end