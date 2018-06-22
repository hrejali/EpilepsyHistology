function [Output]= FGConnectedComp(seg,lap)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 14th, 2018
%Title: Creating Sub-images from disconnected foreground components

%% ............................Description................................
% This is meant for Segmented images which have multiple disconnected 
% foreground components. The algorithm will determine number of diconnected
% components (n) and isolate each connected component. The output of the
% function is n number of sub images, each sub image is a cropped image
% containing a particular connected forground component


%Inputs:
% 1) Segmented image with multiple disconnected forground components
% 1) Laplac's image croped to match the above images

%Outputs:
% 2) Sub-images containing a specific connected foreground component

%% ... Determine number and Isolated the connected forground components ...

conncomp=bwconncomp(seg==1);
NumFGComp=conncomp.NumObjects;
listFGComp=conncomp.PixelIdxList;

%% ....................... Creat Sub images .............................
Output=struct;
for i=1:NumFGComp
    subimg=seg;
    subimg(listFGComp{i})=10;
    %determine x and y limits to crop image
    [x, y] = find(subimg==10);
    subimg(listFGComp{i})=1; % change back label to 1
    x_max = max(x)+2; x_min = min(x)-2;
    y_max = max(y)+2; y_min = min(y)-2;
    subimg = imcrop(subimg,[y_min x_min (y_max-y_min) (x_max-x_min)]);
    subLapImg = imcrop(lap,[y_min x_min (y_max-y_min) (x_max-x_min)]);
    Output.Comp(i).img = subimg;
    Output.Comp(i).laplace = subLapImg;
    Output.hdr.Comp(i).Xlim=[x_min x_max];
    Output.hdr.Comp(i).Ylim=[y_min y_max];
end
Output.hdr.NumFGComp=NumFGComp;


end
