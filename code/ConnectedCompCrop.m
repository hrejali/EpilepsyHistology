%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: September 19th,2018
%Title: ConnectedCompCrop
function [imgOut]=ConnectedCompCrop(img,hdr)
%% ............................ Description ...............................
% ConnectedCompCrop(img,ConnectedComp)

% Algorithm will crop specfied image into multiple components. 
% The connected components are determined from FGConnectedComp algorithm and
% stored in structure obtained from StreamlineComp Algorithm. This function
% will be used to crop Feature Maps into (n) number of components

%Inputs:
% 1) <img> Image to be cropped.
% 2) <hdr> Header structure obtained from StreamlineComp Output

%Outputs:
% 2) <imgOut> Cropped image(s)
%% Use Header To Crop Image into Connected Components
imgOut=hdr;
for i=hdr.NumFGComp
    Ylim=hdr.Comp(i).Ylim;
    Xlim=hdr.Comp(i).Xlim;
    imgOut.Comp(i).img=imcrop(img,[Ylim(1) Xlim(1) (Ylim(2)-Ylim(1)) (Xlim(2)-Xlim(1))]);
end
end