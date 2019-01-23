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
SegImage = load_untouch_nii(Image_dir); % using untouch load because had problems with images re-orienting
seg=SegImage.img;
%if(ndims(seg)==2)
% Making the 2D image a 3D image to allow the Laplace solver to run
%seg(:,:,2) = seg;
%end
% kernal = strel('square',2);
% GM=imdilate(seg==1,kernal);
% seg(GM==1)=1;
%% ........DEFINE FORGROUND SOURCE AND SINK (BOUNDARY COND SETUP)...........
sz = size(seg);
fg = find(seg == 1); % Grey Matter
src = find(seg == 2);% White Matter
snk = find(seg == 3);% Background
init = zeros(size(fg))+0.5;

%% ...............................LAPLACE SOLVER..........................
numiter = 5000; % max finite difference iterations
try
    LPfield = laplace_iters_mex(fg, src, snk, init, numiter, sz);
catch
    disp('mex of laplace_iters failed, using non-mex file instead (slower, but will produce the same results). Retry laplace_iters_mex.prj (using MATLAB Coder) for faster results.');
    LPfield = laplace_iters(fg, src, snk, init, numiter, sz);
end
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
%save_nii(LPfieldImage,[Output_dir,'/',name,'_Laplacian.nii.gz']);

% ......................................................................
%% ........................ Divide Image into Sub Image .................
Output=FGConnectedComp(seg,LPfield);
NumFGComp=Output.hdr.NumFGComp;

%% ............ Streamline Computation and PreProcessing Steps  ...........
%Computation is done on each sub-image
for i=1:NumFGComp
    try
        Streams=StreamPreProc(Output.Comp(i).img,Output.Comp(i).laplace);
        Output.Comp(i).Streams=Streams.data(3).Streams;
    catch
        disp(['Error in computation of sub-image component ',num2str(i)])
    end
end
Output.hdr.slice=name;

%% ........................... Save Results ...............................
save([Output_dir,'/',name,'.mat'],'-struct','Output');

Output_dir=[Output_dir,'/images'];
% save images
if ~exist(Output_dir, 'dir')
    mkdir(Output_dir)
end
for i=1:NumFGComp
    Fig=figure;
    imagesc(Output.Comp(i).img);
    DispStreamLineOrder(Output.Comp(i).Streams);
    saveas(Fig,[Output_dir,'/',name,'_Comp',num2str(i),'.png'])
end

end


