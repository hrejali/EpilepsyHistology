%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: November 12th,2018
%Title: Get Global Parameters 
function [globalParm,profileList] = getGlobalParm(subjList)
%% ............................Description................................
% getGlobalParm()
% Determines Reference and other global parameters 

%Inputs:
% 1) <subjList>: List of outputs from multiple subjects  

%Outputs:
% 1) <globalParm>: Global parameters for mutliple subjects
%   - gobalParm(1)= Reference, 
%   - globalParm(2) = Segment length,
%   - globalParm(3) = slack
%% Concatenate Profile Area's across components and subjects/slides
profileList=[];
for i=1:length(subjList)
    
    NumComp=subjList(i).hdr.NumFGComp;
    for j=1:NumComp
        profileList=[profileList subjList(i).Comp(j).Area.Profiles];
    end
end
%% Get Global Reference
% will choose a reference with the minimum average eucidien distance across
% list
[globalRef,~,~] = ReferenceLoc(profileList);

%% Get Global Slack and Segment Length Parameters
segmentMin=35;segmentMax=105;
slackMin=5; slackMax=30;
optim_pars=optim_cow(profileList',[segmentMin, segmentMax, slackMin, slackMax],[0 10 30 0.1],globalRef(:,1)');

%% Store Global Parameters
globalParm(1)=globalRef;
%Segment Length/Slack
globalParm(2)=optim_pars(1);globalParm(3)=optim_pars(2);

end