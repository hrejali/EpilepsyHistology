%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Resample Streamlines 
function [AreaInterpolant,List,DepthInterpolant]= ParameterizeStreamArea(Streams)
%% ............................ Description ...............................
% ParameterizeStream(Streams)
% Parameterize streamline to F(#,Area)

%Inputs:
% 1) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image

%Outputs:
% 1) <Profile>: List of Profiles.
%% ...................... Find Length of each Streamline .................
[List, DepthInterpolant]=InterStreamArea(Streams);

%% ............ Scatter Interp Preparation And Computation ................
Area=[];
StreamNum=[];NumStreams=length(Streams);
X=[];Y=[];
for i = 1:NumStreams-1
 
    X=[X List.Stream(i).X'];
    Y=[Y List.Stream(i).Y'];
    Area=[Area List.Stream(i).Area'];
    for j = 1:1/(List.StepSize)+1
        temp(j)=i;
    end
    StreamNum=[StreamNum temp];
    temp=[];
end
Fx=scatteredInterpolant(StreamNum(:),Area(:),X(:),'linear','none');
Fy=scatteredInterpolant(StreamNum(:),Area(:),Y(:),'linear','none');
% Determine the Inverse interpolant

Depth=0:List.StepSize:1;
Depth=(ones(1/List.StepSize+1,NumStreams-1).*Depth'); % Areas were obtained at equally spaced Depths
FArea=scatteredInterpolant(StreamNum(:),Depth(:),Area(:),'linear','none');

F.Fx=Fx;
F.Fy=Fy;
FInv.FArea=FArea;

AreaInterpolant.F=F;
AreaInterpolant.FInv=FInv;

end