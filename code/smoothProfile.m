function [PSmooth]= smoothProfile(Profile,SPAN)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: April 17th, 2018
%Title: Smooth Profile

%% ............................Description................................
% Smooths profile at each cortical depth (Every Row)

%Inputs:
% 1) Segmented image
% 2) Laplace Image 

%Outputs:
% 2) Output containing streamlines from WM, GM and merged streamlines
%% .........................Smooth along rows............................
sz=size(Profile);
for i=1:sz(1)
    PSmooth(i,:)=smooth(Profile(i,:),SPAN);
end
