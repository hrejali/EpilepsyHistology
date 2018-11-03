%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Bin Profile
function [Profiles,F,FInv]= ProfileExtraction(img,Stream,interp)
%% ............................ Description ...............................
% ProfileExtraction(img,Stream,interp)
% Bins and averages specified number of profiles  

%Inputs:
% 1) <Img>: MR or Histological img 
% 2) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image
% 3) <interp>: interpolation method -- Defualt: 'Linear'

%Outputs:
% 1) <Profiles>: List of Profiles.
%% Check Interp input 
if isempty(interp)
    interp='linear';
end
%% ....... Reparameterize Streamlines by Cortical Depth Percentage .............
NumStreams=length(Stream);
[F,FInv]=ParameterizeStreamArea(Stream); % Fx,y(streamline index, percentage depth [0 1])
Fx=F.Fx;Fy=F.Fy;
%% Equally Resample along Each Streamline 
Profiles=EquiResample(Fx,Fy,img,interp);

end