%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 15th,2018
%Title: Generate Streamline Features
function [dataList]= genStreamlineFeatures(in_dir,list_dir,out_dir)
%% ............................ Description ...............................
% genStreamlineFeatures(in_dir,list_dir,out_dir)
% Generates Streamline specific Features (Curvature, Cortical Thickness)
% for all subjects (data) in strucutre to be later processed
% This code is meant to medium bewteen runStreamlineFeatures bash script

%Inputs:
% 1) <in_dir>: Input Directory of Processed Profiles .mat files for Subject and Slide

% 2) <out_dir>: Directory to save processed .mat files
%% Initialize Variablessubj_dir
res='100um_5umPad';
profileFolder=[res,'_AlignedProfiles'];

%% Load Information from List_dir
subjList=importdata(list_dir,'\n');
lenSubj=length(subjList);
%% Load data and Save
CurvatureList=[];ThicknessList=[];
for i = 1:lenSubj
    subj_dir=[in_dir,'/',cell2mat(subjList(i))];
    
    slideList=dir([subj_dir,'/',profileFolder,'/EPI*.mat']);
    numSlides=size(slideList);
    for j=1:numSlides(1)
        data_dir=[slideList(j).folder,'/',slideList(j).name];
        slide=load(data_dir);
        numComp=length(slide.Comp);
        for k=1:numComp
            % Curvature
            [Curvature,figCurvature]=getCurvature(slide.Comp(k));
            slide.Comp(k).Curv=Curvature;
            CurvatureList=[CurvatureList Curvature];
            
            % Thickness
            Thickness=getCorticalThickness(slide.Comp(k).Streams);
            [figTickness]=DispStreamlineThickness(Comp);
            slide.Comp(k).Thick=Thickness;
            ThicknessList=[ThicknessList Thickness];
            
            % Save updated structure.
            save([data_dir,'2.mat'],'-struct','slide');
            
            % Save Images
            saveas(figCurvature,[data_dir,'/images/',slideList(j).name,'_Curvature_Comp',num2str(k),'.png']);
            close(figCurvature);
            
            saveas(figTickness,[data_dir,'/images/',slideList(j).name,'_Thickness_Comp',num2str(k),'.png']);
            close(figTickness);
        end

    end
end

if ~exist([out_dir,'/StreamLineFeatures'], 'dir')
    mkdir([out_dir,'/StreamLineFeatures'])
end
save([out_dir,'/StreamLineFeatures/List.mat'],'dataList','-v7.3');

end