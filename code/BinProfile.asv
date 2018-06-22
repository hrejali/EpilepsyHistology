%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Bin Profile
function [binprofile]= BinProfile(img,Streams,numProfile2Bin)
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
%% ...................... Find Length of each Streamline .................
NumStreams=length(Streams);
lenStreams=zeros(NumStreams,1);
CorticalDepth=struct;
for i = 1:NumStreams
    lenStreams(i)=length(Streams{i});
    CorticalDepth(i).stream=CorticalDepthPer(Streams{i});
end

%% ..................... Scatter Interp Preparation .....................
CorticalDepthVec=[];
StreamNum=[];
X=[];
Y=[];
for i = 1:NumStreams
    s=Streams{i};
    X=[X s(:,1)'];
    Y=[Y s(:,2)'];
    CorticalDepthVec=[CorticalDepthVec CorticalDepth(i).stream];
    for j = 1:lenStreams(i)
        temp(j)=i;
    end
    StreamNum=[StreamNum temp];
    temp=[];
end
Fx=scatteredInterpolant(StreamNum',CorticalDepthVec',X','linear','none');
Fy=scatteredInterpolant(StreamNum',CorticalDepthVec',Y','linear','none');
%% .................... Sample Streamlines and Bin Them ..................
Depth=0:1/100:1;
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
    binprofile(:,i+1)=mean(bin','omitnan')';
end

end