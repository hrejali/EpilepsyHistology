%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: August 2nd,2018
%Title: Align Profile (Additional Correction)
function [AlignedProfile,WarpingStruct,Refloc]=AlignProfile(Profiles)
%% ............................ Description ...............................
% AlignProfile(Profiles)
% Algoirithm will locally align profiles in order to minimize distortion
% required, this is done by choosing a small bin size. NOTE the amouunt
% of distortion is proportional to amount of information lost [3].The Entire set is
% divided in a number of bins which alignment is done

% Alignment method (icoshift):
%   Code: [1] https://www.mathworks.com/matlabcentral/fileexchange/29359-icoshift-interval-correlation-optimized-shifting-for-matlab-v-2014b-and-above
%   Paper: [2] https://www.sciencedirect.com/science/article/pii/S1090780709003334
%   Review: [3] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3901265/

% Correction Method:
% Will correct or align profiles by shifting and compressing&stretching profiles
% to a virtual reference.

% Pairwise(Reference):
% Pairwise methods require a reference profile ( spectrum ) in which other profiles
% are aligned with either one is created or selecres -- The virtual reference is obtained as the average profile of a set

% Criteria or Target Function:
% Method used for correction uses FFT correction, this method significantly
% speeds up computational time compared with other target functions

%Inputs:
% 1) <Profile>: Entire Profile Set
%Outputs:
% 1) <AlignedProfile>: Aligned Profile Set
%% ......................... Initialization ...............................
WarpingStruct=struct;
iter=1;
%% In Real Time Determine Reference and Peform Alignment
%loop through every profile in blocks (#blocks=iters)

AlignedProfile=Profiles;
%% Determine Reference
% ReferenceLoc-Using distance metric to determine the best or most similar profile
% within set
[~,Refloc,~,DisMat]=ReferenceLoc(AlignedProfile);
%Refloc=216;
%Refloc=450;
Ref=AlignedProfile(:,Refloc);
iter=1;
while(1)
    [~,PFeat]=ExtractFeat(Ref); % Calculate Features from Previous Reference
    %% Determine Optimal Warping using COW
    [Warping,~,~]=cow(Ref',AlignedProfile',floor(1000/6),floor(1000/12));
    %% Smooth Warping Path along profiles and Store Transformation 
    SmoothWarping=SmoothWarp(Warping,50,150);
    WarpingStruct(iter).Transforms=Warping; 
    WarpingStruct(iter).SmoothTransforms=SmoothWarping;
    iter=iter+1; % Record number of iterations
    %% Apply Warping to Data Set & Determine New Reference
    AlignedProfile=cow_apply(AlignedProfile',SmoothWarping)';
    Ref=mean(AlignedProfile,2);
    
    %Determine Distance Bewteen New and Old Reference.
    [~,Feat]=ExtractFeat(Ref);
    distFeat=norm(Feat-PFeat);

    if(distFeat<0.05 || iter==10)
        break;
    end
end
end



