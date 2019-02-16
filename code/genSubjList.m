%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 14th,2018
%Title: Generate Subject List
function [subjList]= genSubjList(in_dir,out_dir)
%% ............................ Description ...............................
% genSubjList(in_dir)
% Generates list of subjects (data) in strucutre to be later processed
% This code is meant to medium bewteen runAlignProfile bash script and 
% appAlignProfile.m Matlab code

%Inputs:
% 1) <in_dir>: Input Directory of Processed Profiles .mat files for Subject and Slide 

% 2) <out_dir>: Directory to save processed .mat files

%% ................ Set Default Values and Check Inputs ..................
if nargin==1 || isempty(out_dir)
    out_dir = './List'; % set output directory to the current directory
end

%% Check Output folder Exist 

if ~exist([out_dir,'/subjList.mat'], 'file')
    Index=1;
else
    temp=load([out_dir,'/subjList.mat']);
    subjList=temp.subjList;
    Index=length(subjList)+1;
end

%% Load data and Save 
subjProfiles=load(in_dir);
subjList(Index) = subjProfiles;
save([out_dir,'/subjList.mat'],'subjList');

end