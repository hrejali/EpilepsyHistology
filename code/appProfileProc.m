%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Feb 4th,2018
%Title: Profile Processing
function [Output]= appProfileProc(in_dir,out_dir,Feature)
%% ............................ Description ...............................
% appProfileProc(in_dir,out_dir)
% Extracts Profiles from FeatureMap along Streamlines - this code is meant
% to medium bewteen runProfileProc bash script and ProfileProc.m Matlab
% code

%Inputs:
% 1) <in_dir>: Input Directory of Processed Streamlines .mat files for Subject and Slide 
% (ex.'E:/EpilepsyQuantHistology/proc/EPI_P015/100um_StreamLines/EPI_P015_Neo_05_NEUN.mat')

% 2) <out_dir>: Directory to save processed .mat files

%Outputs:
% 1) <Output>: struct containing profiles paramertized by depth and Area
% and their foward and inverse interpolants.
%% ................ Set Default Values and Check Inputs ..................
if nargin==1 || isempty(out_dir)
    out_dir = '.'; % set output directory to the current directory
    Feature='count';
end
if nargin==2 || isempty(Feature)
    Feature='count';
    
end
Res='100um_200umPad';

%% ............................Import Data................................
% load Streamlines
Output=load(in_dir);
[dir,slide]=fileparts(in_dir);

%load FeatureMaps
FeatureMap=load([dir,'/../',Res,'_FeatureMaps/',slide,'.mat']);

%% ....................... Run ProfileProc ...............................
index=strfind(cell2mat(FeatureMap.features),Feature);
temp=FeatureMap.featureVec(:,:,index);
temp=temp(:,end:-1:1)';
Output=ProfileProc(temp,Output);

%% ......................... Save Results ...............................
save([out_dir,'/',slide,'.mat'],'-struct','Output');

out_dir=[out_dir,'/images'];
% save images
if ~exist(out_dir, 'dir')
    mkdir(out_dir)
end

NumFGComp=Output.hdr.NumFGComp;
% Save FeatureMaps + Streamline images 
for i=1:NumFGComp
    Fig=figure;
    imagesc(Output.Comp(i).FeatureMap);
    DispStreamLineOrder(Output.Comp(i).Streams);
    saveas(Fig,[out_dir,'/',slide,'_Comp',num2str(i),'.png'])
end

% Save Profile images
for i=1:NumFGComp
    Fig=figure;
    subplot(2,1,1);imagesc(Output.Comp(i).Depth.Profiles);
    title('Original Profiles');
    subplot(2,1,2);imagesc(Output.Comp(i).Area.Profiles);
    title('Iso-Area Corrected Profiles');
    saveas(Fig,[out_dir,'/',slide,'_Profiles_Comp',num2str(i),'.png'])
end

end

