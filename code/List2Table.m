%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 21st,2018
%Title: List to Table
function [T]=List2Table(ListDir,outDir)
%% ............................ Description ...............................
% List2Table(ListDir)
% Converts list of subjects and summarizes relevant data to a table

%Inputs:
% 1) <ListDir>: Directory of list of data - list is a structure with
% various fields 

%Outputs:
%1) <T> Table output with the following summarized information:
%       Density   (Individual Profile(1x1000))
%       Area      (Individual Profile(1x1000))
%       Curvature (Scalar (1x1))
%       Thickness (Scalar (1x1))
%       Subject   (String)
%       Component (Scalar (1x1))
%       Profile#  (Scalar (1x1))
%% ........................... Load In Data ..............................
List1=load([ListDir,'Depth/subjList.mat']);
List2=load([ListDir,'area/subjList.mat']);
%% ............................Create Table................................

VariableName={'Density','Area','Curvature','Thickness','Subject','Component','ProfileNumber'};
NumSubj=length(List1);
T=[];TReduced=[];

for i=1:NumSubj
    
    NumComp=List1(i).hdr.NumFGComp;
    for j=1:NumComp
        % Run through each profile in that component and subject
        [~,NumProfiles]=size(List1(i).Comp(j).Aligned.Profiles);
        for k=1:NumProfiles
            %Profile Features
            Density=List1(i).Comp(j).Aligned.Profiles(:,k)';
            Area=List2(i).Comp(j).Aligned.Profiles(:,k)';
            
            %Data Reduced Profile Features
            [~,DensityReduced]=ExtractFeat(List1(i).Comp(j).Aligned.Profiles(:,k));
            [~,AreaReduced]=ExtractFeat(List2(i).Comp(j).Aligned.Profiles(:,k));
            
            %Streamline Features
            Curvature=List1(i).Comp(j).Curv(k);
            Thickness=List1(i).Comp(j).Thick(k);
            
            %Descriptors
            Subject=List1(i).hdr.slice;
            Component=j;
            ProfileNum=k;
                
            T=[T;table(Density,Area,Curvature,Thickness,string(Subject),Component,ProfileNum)];
            TReduced=[TReduced;table(DensityReduced,AreaReduced,Curvature,Thickness,string(Subject),Component,ProfileNum)];
        end
        
    end
    
end
T.Properties.VariableNames=VariableName;
writetable(T,[outDir,'/Table.csv']);

TReduced.Properties.VariableNames=VariableName;
writetable(TReduced,[outDir,'/TableReduced.csv']);


end