%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Jan 9th,2019
%Title: Import Classified Binary Images - Export Segmentation
function getSegFromMask(subjName)
% Hard Coded Directory
Dir='C:\Users\Hossein\Documents\MASc\Projects\Segmentation';
Output=[Dir,'\segmentation\'];
OutputGraham='E:\EpilepsyQuantHistology\proc\';

maskDir=[Dir,'\masks'];
ListGM = ls([maskDir,'\',subjName,'*GM-mask.png']);
ListWM = ls([maskDir,'\',subjName,'*WM-mask.png']);

[iter,~]=size(ListGM);
for i=1:iter
    imGM=imread([maskDir,'\',ListGM(i,:)]);
    imWM=imread([maskDir,'\',ListWM(i,:)]);
    Segmentation=zeros(size(imGM));
    
    %Set GM=1,WM=2,Bkg=3
    Segmentation(imGM==255)=1;
    Segmentation(imWM==255)=2;
    Segmentation(Segmentation==0)=3;
    
    % Downsample Image to 100um
    Segmentation=imresize(Segmentation,0.2,'nearest');
    %Correct Orientation 
    Segmentation=Segmentation(end:-1:1,:)';
    %Segmentation=Segmentation(:,end:-1:1)';
    
    %check if folder exist in Graham
    segName = erase(ListGM(i,:),'_GM-mask.png');
    OutputSegGraham=[OutputGraham,subjName,'\100um_Segmentations'];
    if ~exist(OutputSegGraham, 'dir')
        mkdir(OutputSegGraham)
    end
    
    %Save Image
    niftiwrite(Segmentation,[Output,segName],'Compressed',true)
    niftiwrite(Segmentation,[OutputSegGraham,'\',segName],'Compressed',true)
end
end