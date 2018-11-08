%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Bin Profile
function [Output]= ProfileExtraction(img,Stream,interp)
%% ............................ Description ...............................
% ProfileExtraction(img,Stream,interp)
% Bins and averages specified number of profiles  

%Inputs:
% 1) <Img>: MR or Histological img 
% 2) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image
% 3) <interp>: interpolation method -- Defualt: 'Linear'

%Outputs:
% 1) <Output>: struct containing profiles paramertized by depth and Area
% and their foward and inverse interpolants.
%% Check Interp input 
if isempty(interp)
    interp='linear';
end
%% ....... Reparameterize Streamlines by Cortical Depth Percentage .............
Output=struct;
[F,FInv]=ParameterizeStream(Stream); % Fx,y(streamline index, percentage depth [0 1])
Output.Depth.F=F;Output.Depth.FInv=FInv;
Fx=F.Fx;Fy=F.Fy;
% Equally Resample along Each Streamline
Profiles=EquiResample(Fx,Fy,img,interp);
Output.Depth.Profiles=Profiles;

%% ....... Reparameterize Streamlines by Cortical Area Percentage .............
[AreaInterpolant,~,DepthInterpolant]=ParameterizeStreamArea(Stream);

Output.Area.F=AreaInterpolant.F;
Output.Area.FInv=AreaInterpolant.FInv;

Output.Depth.F=DepthInterpolant.F;
Output.Depth.FInv=DepthInterpolant.FInv;

%% Equally Resample along Each Streamline
% Depth reparameterization
F=DepthInterpolant.F;
Output.Depth.Profiles=EquiResample(F.Fx,F.Fy,img,interp);

% Area reparameterization
F=AreaInterpolant.F;
Output.Area.Profiles=EquiResample(F.Fx,F.Fy,img,interp);

end