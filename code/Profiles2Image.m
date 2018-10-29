%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: October 13 th,2018
%Title: Profiles2Image(Profiles,Seg,FInv)
function [Image]=Profiles2Image(Profiles,Seg,FInv)
%Profiles2Image(Profiles,Seg,FInv)

%Inputs:
% 1) <Profiles> Set of Profiles 
% 2) <Seg> Segmentation of GM with label of 1
% 3) <FInv> Inverse scattered interpolant

%Outputs:
% 1) Reconstructed image from Profiles

%% Initialization
indx=1;
indy=1;
sz=size(Seg);
num=nan(sz(1),sz(2));
Depth=nan(sz(1),sz(2));
Image=zeros(sz(1),sz(2));
X=1/1000:1/1000:1;
[x,y]=find(Seg==1);
[~,szP]=size(Profiles);
%% Run through Query Points
for i=1:length(x)
      num(y(i),x(i))=FInv.FNumInv(y(i),x(i));
      Depth(y(i),x(i))=FInv.FDepthInv(y(i),x(i));
      if( ~(isnan(num(y(i),x(i)))) && round(num(y(i),x(i)))<szP )
          numIndex=round(num(y(i),x(i)));
          Corr= Depth(y(i),x(i));
          Image(x(i),y(i))=interp1(X,double(Profiles(:,numIndex)),Corr,'linear');
      end
  
end
end