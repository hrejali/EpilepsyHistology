%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: October 8th,2018
%Title: Equal Resampling 
function [Profiles]= EquiResampleInv(FArea,img,interp)
%% ............................ Description ...............................
% EquiResample(Fx,Fy,img,NumStreams,interp)
% Resample the image according to Fx and Fy coordinates

%Inputs:
% 1) <Fx>: Streamline index
% 2) <Fy>: Reparametrize index
% 3) <img>: image to be sampled from
% 4) <interp>: interpolation method

%Outputs:
% 1) <Profiles>: List of Profiles.

%% Initialize Variables
NumStreams=FArea.Points(end,1);
StepSize=1/1000;
Sample=0:StepSize:1-1/1000;X=0:1000-1;
Maxlen=length(Sample);
Corr=ones(Maxlen,2); Corr(:,2)=Sample;
Profiles=zeros(length(Sample),NumStreams);
for i = 1:NumStreams
    Corr(:,1)=i*ones(length(Sample),1);
    CorrY=FArea(Corr)/StepSize; % Divide by Step size
    CorrY(1)=1;
    Profiles(:,i)=interp1(X,double(img(:,i)),CorrY,interp);
end
end