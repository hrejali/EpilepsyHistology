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
SegImage = load_nii(Image_dir);
seg=SegImage.img;
%if(ndims(seg)==2)
    % Making the 2D image a 3D image to allow the Laplace solver to run
    %seg(:,:,2) = seg;
%end

%% ........DEFINE FORGROUND SOURCE AND SINK (BOUNDARY COND SETUP)...........
sz = size(seg);
fg = find(seg == 1); % Grey Matter
src = find(seg == 2);% White Matter
snk = find(seg == 3);% Background
init = zeros(size(fg))+0.5;

%% ...............................LAPLACE SOLVER..........................
numiter = 3000; % max finite difference iterations 
LPfield = laplace_iters_mex(fg,src,snk,init,numiter,sz);
%LPfield = laplace_solver(fg,src,snk,numiter,[],sz);

LPfield(src) = 0;
LPfield(snk) = 1;

LPfieldImage = LPfield;
LPfieldImage = make_nii(LPfieldImage);

%% ......................SAVE LAPLACIAN IMAGE..............................
nameComp = '';
name = Image_dir;
while(~strcmp(name,nameComp))%Extract Name of file from Image_dir
    nameComp = name;
    [~,name,~] = fileparts(name);
    
end
erase(name, '_Seg');
save_nii(LPfieldImage,[Output_dir,'/',name,'_Laplacian.nii.gz']);

% ......................................................................
%% ........................ Divide Image into Sub Image .................
Output=FGConnectedComp(seg,LPfield);
NumFGComp=Output.hdr.NumFGComp;

%% ............ Streamline Computation and PreProcessing Steps  ...........
%Computation is done on each sub-image
for i=1:NumFGComp
   Streams=StreamPreProc(Output.Comp(i).img,Output.Comp(i).laplace);
   Output.Comp(i).Streams=Streams.data(3).Streams;
   
end
Output.hdr.slice=name;

end


