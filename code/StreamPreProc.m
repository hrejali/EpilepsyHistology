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
step_size = 0.1; % amount of sampling for streamline
max_number_verticies = 10000; % max number of verticies
opt = [step_size max_number_verticies]; % options specification for stream2

% .....................WM/GM Boundary Stream lines......................
%converts start points to list of x y coordinates for WM/GM Boundary
%[startpts1,startpts2] = ind2sub(size(edgesWG),find(edgesWG(:,:,1)==1));
% Compute the gradient of the laplacian ImLap
[dx,dy]=gradient(LPfield);
%This returns a list of streamlines, which can be viewed with streamline()
StreamsWM = stream2(dx,dy,WGSorted(:,1),WGSorted(:,2),opt);

% ....................... GM Surface Stream lines.........................
%Delete all points that need to be ignored obtained from IgnoreMask 
GBSorted(IgnoreMask==0,:) = [];
%This returns a list of streamlines for GM Surface
StreamsGM = stream2(-dx,-dy,GBSorted(:,1),GBSorted(:,2), opt);

%% ................. Filter Streamline Points - Mask ......................
% StreamFilt() will mask all the points for each individual streamline
% such that there are no coordinates outside the GM region
sz1=size(StreamsWM); sz2=size(StreamsGM);
%loop through streamline's

for i=1:sz2(2)
    StreamsGM(i)=StreamFilt(seg,StreamsGM(i));
end
for i=1:sz1(2)
    StreamsWM(i)=StreamFiltWM(seg,StreamsWM(i));
end

%% ................................. MERGE STREAMLINES ....................
% Merges streamlines from WM and GM boundary using GM boundary start points
MergedStreams=MergeStream(StreamsWM,StreamsGM,seg);

%% .....................Filter Streamline - Length.......................
% Filter the streamlines that fall below or above 3 std from the mean length
sz=size(MergedStreams);
lenMerged=ones(1,sz(2));
for i=1:sz(2)
    lenMerged(i)=length(MergedStreams{i});
end

MeanLen=mean(lenMerged);STDLen=std(lenMerged);

index=zeros(1,sz(2));
for i=1:sz(2)
    if( lenMerged(i)<=(MeanLen-4*STDLen)  )
        index(i)=1;
    else
        index(i)=0;
    end
end
MergedStreams(index==1)=[];

%% ........................SAVE STREAMLINES IN STRUCT.....................
Output=struct;
Output.hdr.Boundary{1}='GM/WM';Output.hdr.Boundary{2}='GM';
Output.hdr.Boundary{3}='Merged';
Output.data(1).Streams=StreamsWM;Output.data(2).Streams=StreamsGM;
Output.data(3).Streams=MergedStreams;
end
