function [delta1 delta2 ratio]=InterBoundaryDiff(stream1,stream2)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 21st,2018
%Title: Inter-Boundary Difference bewteen neighbouring streamlines
%% ............................Description................................
% InterBoundaryDif(stream1,stream2)
% Determine the difference bewteen coordinates on neighbouring streamlines at the GM
% boundary (delta1) and the difference bewteen the coordinates on
% neighbouring streamlines at the WM boundary
% Hypothesis: delta1/delta2 ratio can give you a measure of degree of 
% curvature experienced by the streamlines

%Inputs:
% 1) <stream1>: streamline 1 which is neighbouring streamline to stream2
% 2) <stream2>: streamline 2 which is neighbouring streamline to stream1

% Assumtions that the streamlines are not cell but arrays!

%Outputs:
% 1) <delta1>: Euclidean distance bewteen coordinates at the GM boundary 
% bewteen streamline 1 and streamline 2 
% 2) <delta2>: Euclidean distance bewteen coordinates at the WM boundary 
% bewteen streamline 1 and streamline 2 
% 3) <ratio>: ratio of delta1 and delta2

%%
len1=length(stream1);
len2=length(stream2);

GMDeltaX=abs(stream1(1,1)-stream2(1,1));
GMDeltaY=abs(stream1(1,1)-stream2(1,1));
delta1=norm(GMDeltaX,GMDeltaY);

WMDeltaX=abs(stream1(len1,1)-stream2(len2,1));
WMDeltaY=abs(stream1(len1,1)-stream2(len2,1));
delta2=norm(WMDeltaX,WMDeltaY);

ratio=delta1/delta2;

end