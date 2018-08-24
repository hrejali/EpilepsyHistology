%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: August 2nd,2018
%Title: Align Profile (Additional Correction)
function [AlignedProfile]=AlignProfile(Profiles)
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
sz=size(Profiles);
numBins=20;
SmoothProfile=zeros(sz);
%% ........................ Smooth Prolfiles .............................
% reason for smoothing the profiles is to produce a better virtual
% reference which is obtained from the averaged profile in a set
for i=1:sz(2)
    %Apply Guassian smoothing to data 
    SmoothProfile(:,i)=smoothdata(Profiles(:,i),'gaussian');
    
end

%%
%loop through every profile
AlignedProfile=Profiles;
for levels=10:-1:1
    shift=0;
    iters=sz(2)/(numBins*levels);
    for i=0:round(iters)-1
        Llimit=(1+i*numBins*levels)-shift;
        Ulimit=(i+1)*numBins*levels-shift;
        if(Ulimit>sz(2))
            Ulimit=sz(2);
        end
        RefLoc=round((Ulimit-Llimit)/2);
        AlignedProfile(:,Llimit:Ulimit)=icoshift(AlignedProfile(:,RefLoc)',AlignedProfile(:,Llimit:Ulimit)',3,'b',[0 1 1])';
        %AlignedProfile(:,Llimit:Ulimit)=cow(AlignedProfile(:,RefLoc)',
        shift=0.5*numBins*levels;
    end
end

end