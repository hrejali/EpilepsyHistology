%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 6th,2019
%Title: Concatenate Profiles
function [profileList] = concatenateProfiles(subjList,dataType,out_dir)
%% ............................Description................................
% concatenateProfiles(subjList)
% links subject profiles together in series

%Inputs:
% 1) <subjList>: List of outputs from multiple subjects  
% 2) <dataType>: (1) to concatenate Iso-Area profiles (Default)
%                (2) to concatenate Aligned Profiles
% 3) <out_dir>: Output directory, if specified will save to directory

%Outputs:
% 2) <profileList>:  List of concatenated profiles from multiple slides and subjects 

%% Initialization and Input Check
profileList=[];

%% Concatenate Profile across components and subjects/slides
for i=1:length(subjList)
    
    NumComp=subjList(i).hdr.NumFGComp;
    for j=1:NumComp
        temp=subjList(i).Comp(j).(dataType).Profiles;
        temp=temp(:,1:end-1);
        profileList=[profileList temp];
    end
end
%% Save Data
if(~isempty(out_dir))
    % Save Data
    save([out_dir,'/',dataType,'Profiles.mat'],'profileList');
    % Save Images
    Fig=figure;imagesc(profileList);
    truesize(Fig,[600 5000]); saveas(Fig,[out_dir,'/',dataType,'Profiles.png']);close(Fig);
    
    Fig=figure;AverageProfilePlot(profileList); saveas(Fig,[out_dir,'/',dataType,'Profiles_AvgProfilePlot.png']);close(Fig);
end

end
