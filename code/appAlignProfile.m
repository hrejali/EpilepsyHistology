%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 14th,2018
%Title: Apply Align Profiles
function appAlignProfile(in_dir,out_dir)
%% ............................ Description ...............................
% appAlignProfile(in_dir,out_dir)
% Align Profiles to a global reference - this code is meant
% to medium bewteen runAlignProfile bash script and AlignProfile.m Matlab
% code
%% Initialize Defualt variables
Res='100um_5umPad';

%% ....... Load dataList and apply iterative alignment algorithm ......... 
load([in_dir,'/','subjList.mat']);
[AlignedProfiles,~,~,dataList]=AlignProfile(dataList);

%% ........................... Store data ................................
save([out_dir,'/',Res,'_Profiles','/AlignedProfiles','.mat'],'AlignedProfiles');
Fig=figure;imagesc(AlignedProfiles); saveas(Fig,[out_dir,'/',Res,'_Profiles','/AlignedProfiles','.png']);

NumSubj=length(dataList);
for i=1:NumSubj
    %% Save subject data
    subj=dataList(i).hdr.slice(1:8);
    dir=[out_dir,'/',subj,'/',Res,'_AlignedProfiles'];
    
    if ~exist(out_dir, 'dir')
        mkdir(out_dir)
    end
    slide=dataList(i).hdr.slice;
    Output=dataList(i);
    save([dir,'/',slide,'.mat'],'-struct','Output');
    
    NumFGComp=dataList.hdr.NumFGComp;
    for j=1:NumFGComp
                
        dir=[dir,'/images'];
        % save images
        if ~exist(out_dir, 'dir')
            mkdir(out_dir)
        end
        %% Save Profiles
        Fig=figure;
        subplot(3,1,1);imagesc(dataList(i).Comp(j).Depth.Profiles);
        title('Original Profiles');
        subplot(3,1,2);imagesc(dataList(i).Comp(j).Area.Profiles);
        title('Iso-Area Corrected Profiles');
        subplot(3,1,3);imagesc(dataList(i).Comp(j).Aligned.Profiles);
        title('Iso-Area + Iterative Warped Profiles');
        saveas(Fig,[dir,'/',slide,'_Profiles_Comp',num2str(i),'.png']);
    end
end

end
