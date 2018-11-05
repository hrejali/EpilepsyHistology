%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: November 1st,2018
%Title: Make Gif
function mkGif(InDir,List,filename,Delay)
%% ............................ Description ...............................
% mkGif(inDir,List,filename,Delay)
% Makes a Gif from the list of images in directory inDir and list of images
% specidied in List.

%Inputs:
% 1) <InDir>: Folder that has images to create GIF
% 2) <List>: List that contains list of image names in directory InDir
% 3) <filename>: Gif filename
% 4) <Delay>:  Delay bewteen images.

filename=[InDir,'/',filename,'.gif'];
for n = 1:length(List)
      im=imread([InDir,'/',cell2mat(List(n))]);
      [imind,cm] = rgb2ind(im,256);
      if n == 1
          imwrite(imind,cm,filename,'gif', 'DelayTime',Delay, 'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', Delay);
      end
end
end