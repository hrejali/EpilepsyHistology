%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 18th,2018
%Title: compare Quality of Alignment

function [sig]=compQualityAlignment(AlignedProfiles,Profiles,Feature)
%% ............................ Description ...............................
% compQualityAlignment(AlignedProfiles,Profiles,Feature)
% Compares the quality of alignment bewteen before and after corrected
% (aligned) profiles. 

%Inputs:
% 1) <Profiles>: List of Profiles from all subjects After correction

% 2) <Profiles>: List of Profiles from all subjects Before correction

% 2) <Feature>: Either curvature or thickness measures, list is equal to
% size of Profiles
%% .................. Get Binned Feature Profile Distances ...............
[lowCorr,medCorr,highCorr]=getBinFeatureProfileDist(AlignedProfiles,Feature);
[low,med,high]=getBinFeatureProfileDist(Profiles,Feature);
%% ........................Plotting Distrubutions ........................ 
figure;histogram(lowCorr); hold on; histogram(low);
legend('After Correction','Before Correction');

figure;histogram(medCorr); hold on; histogram(med);
legend('After Correction','Before Correction');

figure;histogram(highCorr); hold on; histogram(high);
legend('After Correction','Before Correction');
%% ........................Test For Significance ........................ 
% Test to see if the alignment was significantly better than original data
[~,sig(1)]=ttest(lowCorr,low);
[~,sig(2)]=ttest(medCorr,med);
[~,sig(3)]=ttest(highCorr,high);

end