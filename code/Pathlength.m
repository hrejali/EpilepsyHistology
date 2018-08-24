%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: July 3rd,2018
%Title: Path Length 
function [Path]= Pathlength(Points)
%% ............................ Description ...............................
% Pathlength(Points)
% The length of the path created from the list of points in Points  

%Inputs:
% 1) <Points>: Point(:,1) refers to all of the x-coordinates and
% Points(:,2) refers to all of the y-coordinates

%Outputs:
% 1) <length>: Pathlength
%%
Path=0;
len=length(Points);
if(isvector(Points))
    return;
else
    for i=1:len-1
        X=abs(Points(i,1)-Points(i+1,1));
        Y=abs(Points(i,2)-Points(i+1,2));
        LineSeg=norm([X Y]);
        Path=Path+LineSeg;
    end
end
end