%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: August 2nd,2018
%Title: Align Profile (Additional Correction)
function [AlignedProfile,WarpingStruct,Ref,subjList]=AlignProfile(subjList,parm)
%% ............................ Description ...............................
% AlignProfile(Profiles)
% Algoirithm will locally align profiles in order to minimize distortion
% required, this is done by choosing a segment size and slack. NOTE the amouunt
% of distortion is proportional to amount of information lost [3].The
% profiles are divided in a number of segments and the slack controls amount of 
% stretching and compression within each segment -- Optimizes the overal
% pearson correlation b/w reference and profiles across all segments

% Alignment method (COW):

%   Code: [1] Aligning of single and multiple wavelength chromatographic
%   profiles for chemometric data analysis using correlation optimized
%   warping 
% ...............(Niels-Pter Vest Nielsen et al, 1998)..................

%   Paper: [2] Automated Alignment of Chromatographic data 
% ..................(Thomas Skov et al, 2008)...........................

%   Review: [3] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3901265/

% Correction Method:
% Will correct or align profiles by compressing & stretching profiles
% to a reference choosen from the data set and than a virtual reference.

% Pairwise(Reference):
% Pairwise methods require a reference profile ( spectrum ) in which other profiles
% are aligned with either one is created or selected -- The virtual reference is obtained as the average profile of a set

% Criteria or Target Function:
% Method used for correction uses Person Correlation

%Inputs:
% 1) <Profile>: Entire Profile Set
%Outputs:
% 1) <AlignedProfile>: Aligned Profile Set
%% ......................... Initialization ...............................
WarpingStruct=struct;
iter=1;
%% Determine Global Parameters
% ReferenceLoc-Using distance metric to determine the best or most similar profile
% within set
[Ref,globalParm,profileList]=getGlobalParm(subjList);
disp('..................Reference Chosen................................')

% [~,Refloc,~,DisMat]=ReferenceLoc(AlignedProfile);
% Ref=AlignedProfile(:,Refloc);
%% In Real Time Determine Reference and Peform Alignment
%loop through every profile in blocks (#blocks=iters)
AlignedProfile=profileList;
while(1)
    %[~,PFeat]=ExtractFeat(Ref); % Calculate Features from Previous Reference
    %% Determine Optimal Warping using COW
    %[Warping,~,~]=cow(Ref',AlignedProfile',globalParm(1),globalParm(2));
    [Warping,~,~]=cow(Ref',AlignedProfile',parm(2),parm(3));
    
    %% Smooth Warping Path along profiles and Store Transformation 
    SmoothWarping=SmoothWarp(Warping,parm(1),3*parm(1));
    WarpingStruct(iter).Transforms=Warping; 
    WarpingStruct(iter).SmoothTransforms=SmoothWarping;
    iter=iter+1; % Record number of iterations
    %% Apply Warping to Data Set & Determine New Reference
    AlignedProfile=cow_apply(AlignedProfile',SmoothWarping)';
    prevRef=Ref;
    Ref=mean(AlignedProfile,2);
    
    %Determine Distance Bewteen New and Old Reference.
    %[~,Feat]=ExtractFeat(Ref);
    distFeat=norm(prevRef-Ref);

    if(distFeat<0.1 || iter==5)
        break;
    end
end
%% Reconstruct Data
start=1;
for i=1:length(subjList)
    NumComp=subjList(i).hdr.NumFGComp;
    for j=1:NumComp
        [~,numProfiles]=size(subjList(i).Comp(j).Area.Profiles);
        subjList(i).Comp(j).Aligned.Profiles=AlignedProfile(:,start:numProfiles+start-1);
        for k=1:length(WarpingStruct)
            subjList(i).Comp(j).Aligned.Transform(k).WarpMtrx=WarpingStruct(k).Transforms(start:numProfiles+start-1,:,:);
            subjList(i).Comp(j).Aligned.Transform(k).SmoothWarpMtrx=WarpingStruct(k).SmoothTransforms(start:numProfiles+start-1,:,:);

        end
        start=start+numProfiles;

    end
end

end