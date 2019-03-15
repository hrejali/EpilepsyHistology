%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 13th,2019
%Title: Get Cortical Thickness
function [Thickness]= getCorticalThickness(Streamlines)
%% ............................Description................................
% getCorticalThickness(Streamlines)
% Gets cortical thickness of each streamline 

%Inputs:
% 1) <Streamlines>: List of Streamlines

%Outputs:
% 2) <Thickness>:  List of thickness values for each Streamline

[~,numStream]=size(Streamlines);

%% ................. Pathlenth and Cortical Depth Calculation ............
for i=1:numStream
Thickness(i)=Pathlength(cell2mat(Streamlines(i)));
end
%% Smooth Cortical Thickness 
Thickness=smooth(Thickness,80)';


end