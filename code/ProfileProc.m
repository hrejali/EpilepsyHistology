%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 15th,2018
%Title: Profile Processing
function [Output]= ProfileProc(FeatureMap,Output)
%% ............................ Description ...............................
% ProfileProc(FeatureMap,Streamlines)
% Extracts Profiles from FeatureMap along Streamlines

%Inputs:
% 1) <FeatureMap>: Feature Map to sample from
% 2) <Streamlines>: Streamlines generated from equipotential model

%Outputs:
% 1) <Output>: struct containing profiles paramertized by depth and Area
% and their foward and inverse interpolants.
%% Crop Feature Maps
FeatureMap=ConnectedCompCrop(FeatureMap.img,Output.hdr);
%% Profile Extraction and Iso-Area Correction
for i=1:Output.hdr.NumFGComp
    %% Smooth Feature Maps
    kernal=[1 1 1; 1 1 1; 1 1 1]*1/9;
    FeatureMap_Smooth=conv2(FeatureMap.Comp(i).img,kernal,'same');
    FeatureMap_Smooth=conv2(FeatureMap_Smooth,kernal,'same');
    %% Profile Extraction + Iso-Area Correction
    temp=ProfileExtraction(FeatureMap_Smooth,Output.Comp(i).Streams,'linear');
    
    %% Store Data 
    Output.Comp(i).FeatureMap=FeatureMap_Smooth;
    Output.Comp(i).Area=temp.Area;
    Output.Comp(i).Depth=temp.Depth;
    
end
 
end
