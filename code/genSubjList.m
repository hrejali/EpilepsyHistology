%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 14th,2018
%Title: Generate Subject List
function [dataList]= genSubjList(in_dir,list_dir,out_dir,Feature)
%% ............................ Description ...............................
% genSubjList(in_dir)
% Generates list of subjects (data) in strucutre to be later processed
% This code is meant to medium bewteen runAlignProfile bash script and 
% appAlignProfile.m Matlab code

%Inputs:
% 1) <in_dir>: Input Directory of Processed Profiles .mat files for Subject and Slide 

% 2) <out_dir>: Directory to save processed .mat files
%% Initialize Variablessubj_dir
res='100um_5umPad';
%% ................ Set Default Values and Check Inputs ..................
if nargin==2 || isempty(out_dir)
    out_dir = './List'; % set output directory to the current directory
end
if isempty(Feature)
    Feature='count';
end
% check type of feature map
if(strcmp(Feature,'count'))
    profileFolder=[res,'_Profiles/',Feature];
else
    profileFolder=[res,'_AlignedProfiles/',Feature];
    %profileFolder=[res,'_AlignedProfiles'];
end
%% Load Information from List_dir
subjList=importdata(list_dir,'\n');
lenSubj=length(subjList);
%% Load data and Save
Index=1;
for i = 1:lenSubj
    subj_dir=[in_dir,'/',cell2mat(subjList(i)),'/',profileFolder];
    slideList=dir([subj_dir,'/EPI*N.mat']);
    numSlides=size(slideList);
    for j=1:numSlides(1)
        data_dir=[slideList(j).folder,'/',slideList(j).name];
        subjProfiles=load(data_dir);
        dataList(Index) = subjProfiles;
        Index=Index+1;
    end
end

if ~exist([out_dir,'/',Feature], 'dir')
    mkdir([out_dir,'/',Feature])
end
save([out_dir,'/',Feature,'/subjList.mat'],'dataList','-v7.3');
%% Save Concatenated Profiles
% if the feature map is not count save concatenated Profiles
if(~strcmp(Feature,'count'))
 
    out_dir=[in_dir,'/',res,'_Profiles'];
    if ~exist([out_dir,'/',Feature], 'dir')
        mkdir([out_dir,'/',Feature])
    end
    % added an extra layer in the struct - Removing that extra layer;
    % ADD THIS BACK
%     for i=1:length(dataList)
%         List(i)=dataList(i).Data;
%     end
%
    concatenateProfiles(dataList,Feature,[out_dir,'/',Feature])
end
end