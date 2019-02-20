%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 14th,2018
%Title: Apply Align Profiles
function appAlignProfile(in_dir,out_dir,parm)
%% ............................ Description ...............................
% appAlignProfile(in_dir,out_dir)
% Align Profiles to a global reference - this code is meant
% to medium bewteen runAlignProfile bash script and AlignProfile.m Matlab
% code
%parm(1) - sigma for smoothing
%parm(2) - Segment Length 
%parm(3) - Slack
%% Initialize Defualt variables
Res='100um_5umPad';

%% ....... Load dataList and apply iterative alignment algorithm ......... 
disp('....................Before Loadining Data..........................')
load([in_dir,'/','subjList.mat']);
disp('....................After Loadining Data...........................')
[AlignedProfiles,~,~,dataList]=AlignProfile(dataList,parm);
disp('...................... AlignProfile Ran ...........................')

%% ........................... Store data ................................
dir=[out_dir,'/',Res,'_Profiles'];
if ~exist(dir, 'dir')
    mkdir(dir)
end
name=['AlignedProfiles_sig-',num2str(parm(1)),'_segLen-',num2str(parm(2)),'_slack-',num2str(parm(3))];
save([dir,'/',name,'.mat'],'AlignedProfiles');
Fig=figure;imagesc(AlignedProfiles); truesize(Fig,[600 5000]); saveas(Fig,[dir,'/',name,'.png']);

% NumSubj=length(dataList);
% for i=1:NumSubj
%     %% Save subject data
%     subj=dataList(i).hdr.slice(1:8);
%     dir=[out_dir,'/',subj,'/',Res,'_AlignedProfiles'];
%     
%     if ~exist(dir, 'dir')
%         mkdir(dir)
%     end
%     slide=dataList(i).hdr.slice;
%     Output=dataList(i);
%     save([dir,'/',slide,'.mat'],'-struct','Output');
%     
%     NumFGComp=dataList(i).hdr.NumFGComp;
%     for j=1:NumFGComp
%                 
%         dir=[dir,'/images'];
%         % save images
%         if ~exist(dir, 'dir')
%             mkdir(dir)
%         end
%         %% Save Profiles
%         Fig=figure;
%         subplot(3,1,1);imagesc(dataList(i).Comp(j).Depth.Profiles);
%         title('Original Profiles');
%         subplot(3,1,2);imagesc(dataList(i).Comp(j).Area.Profiles);
%         title('Iso-Area Corrected Profiles');
%         subplot(3,1,3);imagesc(dataList(i).Comp(j).Aligned.Profiles);
%         title('Iso-Area + Iterative Warped Profiles');
%         saveas(Fig,[dir,'/',slide,'_Profiles_Comp',num2str(i),'.png']);
%     end
% end
disp('............... Code Sucessfully Ran Without Error ................')

end
