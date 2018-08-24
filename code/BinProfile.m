%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Bin Profile
function [binprofile]= BinProfile(img,Stream,numProfile2Bin)
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
[Fx,Fy]=ParameterizeStream(Stream); % Fx,y(streamline index, percentage depth [0 1])
%%
Depth=0:1/1000:1-1/1000;
Maxlen=length(Depth);
Corr=ones(Maxlen,2); Corr(:,2)=Depth;
bin=NaN(Maxlen,numProfile2Bin);
for i = 0:NumStreams-numProfile2Bin-1
    Corr(:,1)=i+1;
    CorrX=Fx(Corr);
    CorrY=Fy(Corr);
    for j = 1:numProfile2Bin
        % Sample from Streamlines
        bin(:,j) = SampleStream(img,[CorrX CorrY]);
        
    end
    %binprofile(:,i+1)=mean(bin','omitnan')';
end

end