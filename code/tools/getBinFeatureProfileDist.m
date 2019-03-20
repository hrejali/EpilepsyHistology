%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 18th,2018
%Title: get Binned Feature Profile Distances
function [DistLow, DistMed, DistHigh] = getBinFeatureProfileDist(Profiles,Feature)
%% ............................ Description ...............................
% getBinFeatureProfileDist(Profiles,Feature)
% Bins Feature(Thickness, or Curvature) into 3 Bins (Low,Med,High),
% proceeds by finding the distances from the average profile in each bin to
% individual profiles within bins

%Inputs:
% 1) <Profiles>: List of Profiles from all subjects

% 2) <Feature>: Either curvature or thickness measures, list is equal to
% size of Profiles

%% ..................Bin Feature into 3 Bins..............................
Med=~isoutlier(Feature,'ThresholdFactor',2);
[~,low,high]=isoutlier(Feature,'ThresholdFactor',2);
low=Feature<=low;
high=Feature>=high;
%% ..Calculate Profile distances from average profile (Alignment Metric)..
[MeanProfileMed, ~]=AverageProfilePlot(Profiles(:,Med));
DistMed=InterProfileDistance(MeanProfileMed,Profiles(:,Med));

[MeanProfileLow, ~]=AverageProfilePlot(Profiles(:,low));
DistLow=InterProfileDistance(MeanProfileLow,Profiles(:,low));

[MeanProfileHigh, ~]=AverageProfilePlot(Profiles(:,high));
DistHigh=InterProfileDistance(MeanProfileHigh,Profiles(:,high));

end