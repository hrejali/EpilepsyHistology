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

% 1) Input directory specifying the segmeneted histological slice
% 2) Output directory; specifies location to save the laplcian image as a
% compressed nifti
% 3) Output is a structure containing the streamlines with header info

%% .....................Check number of inputs........................
if nargin == 1   % if the number of inputs equals 1
    Output_dir = '.'; % set output directory to the current directory
end
%% ..................Import and Check Image Dim...........................
HSeg_Im = load_nii(Image_dir);
if(ndims(HSeg_Im.img)==2)
    % Makign the 2D image a 3D image to allow the Laplace equation to run
    HSeg_Im.img(:,:,2) = zeros(size(HSeg_Im.img));
end
%% ........DEFINE FORGROUND SOURCE AND SINK (BOUNDARY COND SETUP)...........
sz = size(HSeg_Im.img);
fg = find(HSeg_Im.img==1); % Grey Matter
src = find(HSeg_Im.img==2);% White Matter
snk = find(HSeg_Im.img==3);% Background
%% ...............................LAPLACE SOLVER..........................
numiter=5000;
LPfield = laplace_solver(fg,src,snk,numiter,[],sz);
LPfieldImage = HSeg_Im;
LPfieldImage.img = zeros(sz);
LPfieldImage.img(fg) = LPfield;
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
%% ...................BOUNDRY CONDITION EXTRACTION.........................
se = strel('sphere',1);
%this finds start points on the source edge inside the greymatter
edgesWG = imdilate(HSeg_Im.img==2,se) & HSeg_Im.img==1;
%this finds start points on the forground edge
edgesGB = imdilate(HSeg_Im.img==3,se) & HSeg_Im.img==1;

%% .....................WM/GM Boundary Stream lines......................
%converts start points to list of x y z coordinates for WM/GM Boundary
[startpts1,startpts2] = ind2sub(size(edgesWG),find(edgesWG(:,:,1)==1));
% Compute the gradient of the laplacian ImLap
[dx,dy]=gradient(ImLap);
%This returns a list of streamlines, which can be viewed with streamline()
streams1 = stream2(dx,dy,startpts2,startpts1, [1 1000000]);
%% ....................... GM Surface Stream lines.........................
%converts start points to list of x y z coordinates for Background/GM Boundary
[startpts1,startpts2] = ind2sub(size(edgesGB),find(edgesGB(:,:,1)==1));
% Compute the gradient of the laplacian ImLap
[dx,dy]=gradient(ImLap);
%This returns a list of streamlines for GM Surface
streams2 = stream2(-dx,-dy,startpts2,startpts1, [1 1000000]);
%% .................................DISPLAY................................
% Display Laplace image
figure; hold on
imagesc(ImLap); colormap('jet');
% scatter(startpts2,startpts1);
s1=streamline(streams1);
s2=streamline(streams2);
%% ........................SAVE STREAMLINES IN STRUCT.....................
Output=struct;
Output.hdr.Boundary{1}='GM/WM';Output.hdr.Boundary{2}='GM';
Output.hdr.ImageName=name;
Output.data(1).Profile=streams1;Output.data(2).Profile=streams2;
end


