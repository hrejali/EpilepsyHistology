%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 27th,2018
%Title: Apply Iterative Warping Transform to new Feature Map.
function [Data]= appXfms(dir,Feature)
%% ............................ Description ...............................
% appXfms(in_dir,out_dir,Feature)
% Applies Iterative Warping transforms to new feature maps. NOTE: The
% Transforms are obtained from data already processed from the count
% Feature Maps.

%Inputs:
% 1) <in_dir>: Input Directory of Slide and Subject in AlignedProfiles Directory  
% (ex.'E:/EpilepsyQuantHistology/proc/EPI_P015/100um_5umPad_AlignedProfiles/EPI_P015_Neo_05_NEUN.mat')

% 2) <out_dir>: Directory to save processed .mat files

%Outputs:
% 1) <Data>: struct containing profiles Aligned.
%% Set Defualt Variables 
Res='100um_5umPad';

%% ............................Import Data................................
% Load Aligned Data
load(dir);
%delete last compenent from in_dir
[dir,slice,ext]=fileparts(dir);

%slice=alignedData.hdr.slice;
% Load Data to be Aligned
Data=load([dir,'/../',Feature,'/',slice,ext]);

%% Obtain Transformations and Apply to Data
NumFGComp=hdr.NumFGComp;
for i=1:NumFGComp
    NumXfms=length(Comp(i).Aligned.Transform);
    
    % Profiles to be aligned - We are smoothing the data here!
    AlignedProfile=smoothProfile(Data.Comp(i).Area.Profiles,10);
    
%     for j=1:NumXfms
%         Warping=Comp(i).Aligned.Transform(j).SmoothWarpMtrx;
%         AlignedProfile=cow_apply(AlignedProfile',Warping)';
%     end

    % Only the last transformation applies!
    Warping=Comp(i).Aligned.Transform(NumXfms).SmoothWarpMtrx;
    AlignedProfile=cow_apply(AlignedProfile',Warping)';
    
    Data.Comp(i).Aligned.Profiles=AlignedProfile;
    Data.Comp(i).Aligned.Transform=Comp(i).Aligned.Transform;
end
%% Save Data
dir=[dir,'/../',Feature];

if ~exist(dir, 'dir')
    mkdir(dir)
end
save([dir,'/',slice,ext],'Data');

%% Save images
for i=1:NumFGComp
    Fig=figure;
    subplot(2,1,1);imagesc(Data.Comp(i).Depth.Profiles);
    title('Original Profiles');
    subplot(2,1,2);imagesc(Data.Comp(i).Aligned.Profiles);
    title('Corrected Profiles');
    
    if ~exist([dir,'/images'], 'dir')
        mkdir([dir,'/images'])
    end
    
    saveas(Fig,[dir,'/images/',slice,'_Profiles_Comp',num2str(i),'.png']);
end

end

