function [Output]= StreamLineComp(Image_dir,Output_dir)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: April 20th,2018
%Title: Constructing Streamlines or Profiles for segmented histology images
%of the cortex
%% ............................Description................................
% ProfileComp(Image_dir,Output_dir)
% NOTE that the laplcian solver and number of other functions are dependent
% on the following github repository:
% https://github.com/jordandekraker/HippUnfolding.git

%Inputs:
% 1) Input directory specifying the segmeneted histological slice
% 2) Output directory; specifies location to save the laplcian image as a
% compressed nifti

%Outputs:
% 3) Output is a structure containing the streamlines with header info

%% .....................Check number of inputs........................
if nargin == 1   % if the number of inputs equals 1
    Output_dir = '.'; % set output directory to the current directory
end
%% ..................Import and Check Image Dim...........................
HSeg_Im = load_nii(Image_dir);
seg=HSeg_Im.img;
if(ndims(seg)==2)
    % Making the 2D image a 3D image to allow the Laplace solver to run
    seg(:,:,2) = zeros(size(seg));
end
%% ........DEFINE FORGROUND SOURCE AND SINK (BOUNDARY COND SETUP)...........
sz = size(seg);
fg = find(seg==1); % Grey Matter
src = find(seg==2);% White Matter
snk = find(seg==3);% Background
%% ...............................LAPLACE SOLVER..........................
numiter=1000; % max finite difference iterations 
LPfield = laplace_solver(fg,src,snk,numiter,[],sz);
LPfieldImage = HSeg_Im;
LPfieldImage.img = zeros(sz);
LPfieldImage.img(fg) = LPfield*100;% decimal values are rounded when save
LPfieldImage.img(:,:,2) = [];

%% ......................SAVE LAPLACIAN IMAGE..............................
nameComp='';
name=Image_dir;
while(~strcmp(name,nameComp))%Extract Name of file from Image_dir
    nameComp=name;
    [~,name,~] = fileparts(name);
    
end
erase(name, '_Seg');
save_nii(LPfieldImage,[Output_dir,'/',name,'_Laplacian.nii.gz']);
%% ......................Create 2D LAPLACIAN IMAGE.........................
ImLap = zeros(sz(1),sz(2));
ImLap(fg) = LPfield;
ImLap(src) = 0;
ImLap(snk) = 1;
%% ....................... SORT SEED POINTS ...............................
seg=HSeg_Im.img(:,:,1);
[GBSorted, WGSorted,IgnoreMask]=SortSeedSub(seg); % sorts the boundary subscripts
GBSorted(:,[1 2])=GBSorted(:,[2 1]); % Columns needed to be swapped
WGSorted(:,[1 2])=WGSorted(:,[2 1]); % Columns needed to be swapped

%% ..................... Produce Stream Lines .............................
step_size=0.5; % amount of sampling for streamline
max_number_verticies=2000; % max number of verticies
opt=[step_size max_number_verticies]; % options specification for stream2
% .....................WM/GM Boundary Stream lines......................
%converts start points to list of x y coordinates for WM/GM Boundary
%[startpts1,startpts2] = ind2sub(size(edgesWG),find(edgesWG(:,:,1)==1));
% Compute the gradient of the laplacian ImLap
[dx,dy]=gradient(ImLap);
%This returns a list of streamlines, which can be viewed with streamline()
streams1 = stream2(dx,dy,WGSorted(:,1),WGSorted(:,2),opt);
% ....................... GM Surface Stream lines.........................
%Delete all points that need to be ignored obtained from IgnoreMask 
GBSorted(IgnoreMask==0,:)=[];
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
%% .................................DISPLAY................................
% Display Laplace image
figure; hold on
imagesc(ImLap); colormap('jet');
streamline(MergedStreams);
%% ........................SAVE STREAMLINES IN STRUCT.....................
Output=struct;
Output.hdr.Boundary{1}='GM/WM';Output.hdr.Boundary{2}='GM';
Output.hdr.Boundary{3}='Merged';
Output.hdr.ImageName=name;
Output.data(1).Streams=streams1;Output.data(2).Streams=streams2;
Output.data(3).Streams=MergedStreams;
end


