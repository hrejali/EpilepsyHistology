%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: October 8th,2018
%Title: Equal Resampling 
function [Profiles]= EquiResample(Fx,Fy,img,interp)
%% ............................ Description ...............................
% EquiResample(Fx,Fy,img,NumStreams,interp)
% Resample the image according to Fx and Fy coordinates

%Inputs:
% 1) <Fx>: Streamline index
% 2) <Fy>: Reparametrize index
% 3) <img>: image to be sampled from
% 4) <numStreams>: number of Streamlines
% 5) <interp>: interpolation method

%Outputs:
% 1) <Profiles>: List of Profiles.

%%
NumStreams=Fx.Points(end,1);
Sample=0:1/1000:1-1/1000;
Maxlen=length(Sample);
Corr=ones(Maxlen,2); Corr(:,2)=Sample;
for i = 1:NumStreams
    Corr(:,1)=i;
    CorrX=Fx(Corr);
    CorrY=Fy(Corr);
    Profiles(:,i)=SampleStream(img,[CorrX CorrY],interp);
end