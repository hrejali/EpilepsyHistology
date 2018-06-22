function [Output]= StreamPreProc(seg,LPfield)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 14th, 2018
%Title: Streamlines computation and Pre-processing 

%% ............................Description................................
% Creates streamlines and does nessecary Pre-Processing steps. 


%Inputs:
% 1) Segmented image
% 2) Laplace Image 

%Outputs:
% 2) Output containing streamlines from WM, GM and merged streamlines

%% ....................... SORT SEED POINTS ...............................
[GBSorted, WGSorted,IgnoreMask] = SortSeedSub(seg); % sorts the boundary subscripts
GBSorted(:,[1 2])=GBSorted(:,[2 1]); % Columns needed to be swapped
WGSorted(:,[1 2])=WGSorted(:,[2 1]); % Columns needed to be swapped

%% ..................... Produce Stream Lines .............................
step_size = 0.5; % amount of sampling for streamline
max_number_verticies = 2000; % max number of verticies
opt = [step_size max_number_verticies]; % options specification for stream2

% .....................WM/GM Boundary Stream lines......................
%converts start points to list of x y coordinates for WM/GM Boundary
%[startpts1,startpts2] = ind2sub(size(edgesWG),find(edgesWG(:,:,1)==1));
% Compute the gradient of the laplacian ImLap
[dx,dy]=gradient(LPfield);
%This returns a list of streamlines, which can be viewed with streamline()
streams1 = stream2(dx,dy,WGSorted(:,1),WGSorted(:,2),opt);

% ....................... GM Surface Stream lines.........................
%Delete all points that need to be ignored obtained from IgnoreMask 
GBSorted(IgnoreMask==0,:) = [];
%This returns a list of streamlines for GM Surface
streams2 = stream2(-dx,-dy,GBSorted(:,1),GBSorted(:,2), opt);

%% ..................... Filter Streamline Points ......................
sz1=size(streams1);
sz2=size(streams2);
%loop through streamline's
for i=1:sz1(2)
    streams1(i)=StreamFilt(seg,streams1(i));
end
for i=1:sz2(2)
    streams2(i)=StreamFilt(seg,streams2(i));
end

%% ................................. MERGE STREAMLINES ....................
% Merges streamlines from WM and GM boundary using GM boundary start points
MergedStreams=MergeStream(streams1,streams2,seg);

%% ........................SAVE STREAMLINES IN STRUCT.....................
Output=struct;
Output.hdr.Boundary{1}='GM/WM';Output.hdr.Boundary{2}='GM';
Output.hdr.Boundary{3}='Merged';
Output.data(1).Streams=streams1;Output.data(2).Streams=streams2;
Output.data(3).Streams=MergedStreams;
end