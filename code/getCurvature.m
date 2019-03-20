%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 11th,2019
%Title: Get Curvature @ 50% cortical depth
function [k,fig]= getCurvature(Comp,Depth)
%% ............................Description................................
% getCurvature(Comp)
% Gets curvature @ 50% cortical depth

%Inputs:
% 1) <Comp>: Individual Component Structure contains ( Depth, and FeatureMap )
% 2) <Depth>: Depth percentage at which curvature is obtain - bewteen (0,1)

%Outputs:
% 2) <k>:  Curvature at along curve produce at specified depth
%% ................ Set Default Values and Check Inputs .................. 
if nargin==1 ||isempty(Depth)
    Depth=0.5;
end
%% ............Obtain Coordinates at 50% depth of cortex...................
X=[];Y=[];
for i=1:length(Comp(1).Streams)
    X=[X Comp(1).Depth.F.Fx(i,Depth)];
    Y=[Y Comp(1).Depth.F.Fy(i,Depth)];
end

% Noisy Coordinates require smoothing 
Xs = smooth(X,50);
Ys = smooth(Y,50);

%% ..........................Calculate Curvature..........................
% Formula: k = (x'*y'' - y'x'')/(x'^2 +y'^2)^3/2
dx = gradient(Xs);
ddx = gradient(dx);
dy = gradient(Ys);
ddy = gradient(dy);
num = dx .* ddy - ddx .* dy;
denom = dx .* dx + dy .* dy;
denom=denom.^(2/3);
curvatur = num ./ denom;

%% .................... Outlier Removal and smoothing ....................
curvatur(isoutlier(curvatur,'mean','ThresholdFactor',3)) = mean(curvatur);
curvatur = smooth(curvatur,80);
%% .................Correct for sign of Curvature........................
%Vector Pointing in direction from Pial to WM surface
V1x=Comp(1).Depth.F.Fx(1,0)-Comp(1).Depth.F.Fx(1,1);
V1y=Comp(1).Depth.F.Fy(1,0)-Comp(1).Depth.F.Fx(1,1);
V1=[V1x V1y 0];

%Vector Pointing in direction from increasing streamline # 
V2x=Comp(1).Depth.F.Fx(1,0)-Comp(1).Depth.F.Fx(2,0);
V2y=Comp(1).Depth.F.Fy(1,0)-Comp(1).Depth.F.Fy(2,0);
V2=[V2x V2y 0];

sgn=sign(cross(V1,V2));
k=curvatur*sgn(3);

%% plot
fig=figure; scatter(Xs,Ys,[],k);
figure;plot(k);
k=k';
end