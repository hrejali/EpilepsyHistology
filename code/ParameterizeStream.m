%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Resample Streamlines 
function [F, FInv]= ParameterizeStream(Streams)
%% ............................ Description ...............................
% ParameterizeStream(Streams)
% Parameterize streamline to F(#,PercentageDepth)

%Inputs:
% 1) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image

%Outputs:
% 1) <Fx>: Streamline Index
% 2) <Fy>: Scattered interpolant of cortical depth along streamline
%% ...................... Find Length of each Streamline .................
NumStreams=length(Streams);
lenStreams=zeros(NumStreams,1);
CorticalDepth=struct;
for i = 1:NumStreams
    lenStreams(i)=length(Streams{i});
    CorticalDepth(i).stream=CorticalDepthPer(Streams{i});
end

%% ............ Scatter Interp Preparation And Computation ................
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
% Inverse scattered interpolant
FNumInv=scatteredInterpolant(X',Y',StreamNum','nearest','none');
FDepthInv=scatteredInterpolant(X',Y',CorticalDepthVec','linear','none');

F.Fx=Fx;FInv.FNumInv=FNumInv;
F.Fy=Fy;FInv.FDepthInv=FDepthInv;

end