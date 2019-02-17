%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 14th,2018
%Title: Generate Subject List
function [subjList]= genSubjList(in_dir,list_dir,out_dir)
%% ............................ Description ...............................
% genSubjList(in_dir)
% Generates list of subjects (data) in strucutre to be later processed
% This code is meant to medium bewteen runAlignProfile bash script and 
% appAlignProfile.m Matlab code

%Inputs:
% 1) <in_dir>: Input Directory of Processed Profiles .mat files for Subject and Slide 

% 2) <out_dir>: Directory to save processed .mat files
%% Initialize Variables
res='100um_5umPad';
%% ................ Set Default Values and Check Inputs ..................
if nargin==1 || isempty(out_dir)
    out_dir = './List'; % set output directory to the current directory
end

%% Load Information from List_dir
subjList=importdata(list_dir,'\n');
lenSubj=length(subjList);
%% Load data and Save
Index=1;
for i = 1:lenSubj
    subj_dir=[in_dir,'/',subjList(i),'/',res,'_Profiles'];
    slideList=ls('EPI*');
    for j=length(slideList)
        data_dir=[subj_dir,'/',slideList(j)];
        subjProfiles=load(data_dir);
        dataList(Index) = subjProfiles;
        Index=Index+1;
    end
end
save([out_dir,'/subjList.mat'],'-struct','dataList');
end