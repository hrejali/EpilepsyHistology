%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: November 12th,2018
%Title: Get Global Parameters 
function [globalRef,globalParm,profileList] = getGlobalParm(subjList)
%% ............................Description................................
% getGlobalParm()
% Determines Reference and other global parameters 

%Inputs:
% 1) <subjList>: List of outputs from multiple subjects  

%Outputs:
% 2) <globalRef>:  Global Reference
% 1) <globalParm>: Global parameters for mutliple subjects
%   - globalParm(1) = Segment length,
%   - globalParm(2) = slack
%% Concatenate Profile Area's across components and subjects/slides
profileList=[];
for i=1:length(subjList)
    
    NumComp=subjList(i).hdr.NumFGComp;
    for j=1:NumComp
        %Store Smoothed Data before 
        PSmooth=smoothProfile(subjList(i).Comp(j).Area.Profiles,10);
        profileList=[profileList PSmooth];
    end
end
%% Get Global Reference
% will choose a reference with the minimum average eucidien distance across
% list
[globalRef,~,~] = ReferenceLoc(profileList);

%% Get Global Slack and Segment Length Parameters
% Decided to choose slack and segments size through trial error will come
% back automate the choice if I have time

% segmentMin=35;segmentMax=105;
% slackMin=5; slackMax=30;
% optim_pars=optim_cow(profileList',[segmentMin, segmentMax, slackMin, slackMax],[0 10 30 0.1],globalRef(:,1)');

optim_pars(1)=100;optim_pars(2)=20;
%% Store Global Parameters
%Segment Length/Slack
globalParm(1)=optim_pars(1);globalParm(2)=optim_pars(2);

end