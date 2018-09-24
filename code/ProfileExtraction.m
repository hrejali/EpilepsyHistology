%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Bin Profile
function [Profiles]= ProfileExtraction(img,Stream,interp)
%% ............................ Description ...............................
% ProfileExtraction(img,Stream,interp)
% Bins and averages specified number of profiles  

%Inputs:
% 1) <Img>: MR or Histological img 
% 2) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image
% 3) <interp>: interpolation method

%Outputs:
% 1) <Profiles>: List of Profiles.
%%

%% ....... Reparameterize Streamlines by Cortical Depth Percentage .............
NumStreams=length(Stream);
[Fx,Fy]=ParameterizeStreamArea(Stream); % Fx,y(streamline index, percentage depth [0 1])
%%
Depth=0:1/1000:1-1/1000;
Maxlen=length(Depth);
Corr=ones(Maxlen,2); Corr(:,2)=Depth;
for i = 1:NumStreams-1
    Corr(:,1)=i;
    CorrX=Fx(Corr);
    CorrY=Fy(Corr);
    Profiles(:,i)=SampleStream(img,[CorrX CorrY],interp);
end

end