%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: October 4th,2018
%Title: LayerFeaturePlot
function [MeanProfile,StdError]=AverageProfilePlot(Profiles)
%AverageProfilePlot(Profiles)

%Will plot avergae profile and standard error 

%Inputs:
% 1) <Profiles> Set of Profiles 

%Outputs:
%1) <MeanProfile> Mean Profile -- avergae profile should indicate degree of
%alignment
%2) <StdError> Mean Profile -- standard error or standard deviation 
%% Deteremine Average Profile and Variability
MeanProfile=mean(Profiles,2);
StdError=std(Profiles')';
%% Plot 
x = linspace(0,100, 1000);
meanPlusSTD = MeanProfile + StdError;
meanMinusSTD = MeanProfile - StdError;
f=fill( [x fliplr(x)],  [meanPlusSTD' fliplr(meanMinusSTD')], 'k');
alpha(.25);
hold on;plot(x, MeanProfile, 'k', 'LineWidth', 2)
%plot(x, meanPlusSTD, 'k')
%plot(x, meanMinusSTD, 'k')


end