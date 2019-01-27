%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: September 7th,2018
%Title: Reference Location
function [Reference,Refloc,RefDist,DisMat]=ReferenceLoc(Profiles)
%% ............................ Description ...............................
% ReferenceLoc(Profiles)

% Algoirithm will determine a reference from the set in Profiles. The
% choice is based on a minimum average distance measure calculated from 
% Dynamic Time Warping Algorithm. 

%Inputs:
% 1) <Profile>: Profile Set
%Outputs:
% 1) <Refloc>: RefLoc
%%
sz=size(Profiles);
DisMat=zeros(sz(2),sz(2));
for i=1:sz(2)
    for j=1:sz(2)
        DisMat(i,j)=sqrt(sum((Profiles(:,i) - Profiles(:,j)) .^ 2));
    end
end
AvgDist=mean(DisMat,2);
Refloc=find(AvgDist==min(AvgDist));
Reference=Profiles(:,Refloc);
RefDist=AvgDist(Refloc);
end
