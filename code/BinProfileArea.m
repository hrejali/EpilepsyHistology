%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Bin Profile
function [binprofile,Area]= BinProfileArea(img,Stream,numProfile2Bin)
%% ............................ Description ...............................
% BinStream(Img,Streams,numStream2Bin)
% Bins and averages specified number of profiles  

%Inputs:
% 1) <Img>: MR or Histological img 
% 2) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image
% 3) <numProfile2Bin>: Number of profiles to bin

%Outputs:
% 1) <BinProfile>: List of Bin Profiles.
%% ....... Reparameterize Streamlines by Cortical Depth Percentage .............
NumStreams=length(Stream);
[Fx,Fy,List]=ParameterizeStreamArea(Stream); % Fx,y(streamline index, percentage depth [0 1])
%%
Maxlen=1/List.StepSize+1;
bin=NaN(Maxlen,numProfile2Bin);
for i = 0:NumStreams-numProfile2Bin-1
    CorrX=List.Stream(i+1).X;
    CorrY=List.Stream(i+1).Y;
    for j = 1:numProfile2Bin
        % Sample from Streamlines
        bin(:,j) = SampleStream(img,[CorrX' CorrY']);
        
    end
    binprofile(:,i+1)=mean(bin','omitnan')';
    Area(:,i+1)=List.Stream(i+1).Area;
end
end