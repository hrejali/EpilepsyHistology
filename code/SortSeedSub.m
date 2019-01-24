%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 22nd,2018
%Title: Sort Boundary/Seed Subscripts (x,y)
function [GBSorted, WGSorted,IgnoreMask]= SortSeedSub(seg)
%% ............................Description................................
% SortSeedSub(Img,Seg)
% Sorts the Boundary subscripts based on the following function:
%                        bwtraceboundary()
% This function requires an inital start point, a Binary image with
% boundary of interest as the foreground. Also requires max number of
% points and inital direction for search.

% Assumes the intersection b/w: WM, GM, BG and Ignore Mask can be specified as
% the initial start point -- Note code can be changed to work under the
% assumption that intersection b/w BG, WM, GM as an initial start point.

%Inputs:
% 1) <Seg>: Segmented image: (GM==1,WM==2,Background==3,Ignore maske==4)
%https://www.mathworks.com/help/images/ref/bwtraceboundary.html

%Outputs:
% 1) <GMSub>: Sorted GM Subscripts
% 2) <WMSub>: Sorted WM Subscripts
% 3) <IgnoreMask>: Mask for Ignore points for the sorted GM subscripts
% IgnoreMask==0 (Ignore Points) IgnoreMask==1 (Valid GM start points)


%% .......................... Boundary Extraction .......................
se = strel('sphere',1);
%this finds start points on the source edge inside the greymatter
edgesWG = imdilate(seg==2,se) & seg==1;
%this finds start points on the forground edge
edgesGB = imdilate(seg==3,se) & seg==1;
% requires a bit of a hack, will need to remove ignore points after sorting 
edgesG = edgesGB + (imdilate(seg==4,se) & seg==1);
%% ............................Starting Point.............................
%se = strel('sphere',1);
se=strel('rectangle',[3 3]);
%Intersection of the 4 labels is assumed to be the starting point
%This point corresponds to neighbouring ignore location (seg==4) in seg
% Note because the Boundary is not closed we will produce 2 starting points
StartPtWM = imdilate(seg==2,se) & imdilate(seg==4,se) & seg==1;
StartPtGM = imdilate(seg==4,se) & imdilate(seg==3,se) & seg==1;

[Px_W,Py_W] = find(StartPtWM==1);
[Px_G,Py_G] = find(StartPtGM==1);


% Start points of boundary is in the 8 neighbourhood of StartPt
for x = -1:1
    for y = -1:1
            % First GM start Point
            if(edgesGB( x+Px_G(1),y+Py_G(1) ))
                GMStart=[x+Px_G(1) y+Py_G(1)];
            end

    end
end

% find the closest point from GMStart point
Pw=[Px_W Py_W];
for i = 1:length(Pw)
    dist(i)=norm(Pw(i,:) - GMStart );
end
[~,index]=min(dist);


for x = -1:1
    for y = -1:1
        if( edgesWG( x+Px_W(index),y+Py_W(index) ) )
            WMStart = [x+Px_W(index) y+Py_W(index)];
        end
        
    end
end


% 

%% ............................Direction.............................
% dictionary for interpertation for x,y in the for loop
dirMatrix=["NW","N","NE";
    "W", "", "E";
    "SW","S","SE"];
%initializing dir variables 
dirWG='';
dirGB='';
% 8 connected neighbourhood check for direction 
for x = -1:1
    for y = -1:1
        if(~(x == 0 && y == 0))
            if( edgesWG( WMStart(1)+x,WMStart(2)+y ) )
                dirWG=dirMatrix(2+x,2+y);
            end
            if( edgesGB( GMStart(1)+x,GMStart(2)+y ) )
                dirGB=dirMatrix(2+x,2+y);
            end
        end
    end
end
%% ......................... Sorting.....................................
% Max # of boundary pixels to extract
GBSize = sum(edgesGB(:)==1);
WGSize = sum(edgesWG(:)==1);

[GBSorted] = bwtraceboundary(edgesGB,GMStart,dirGB,8,GBSize);
[WGSorted] = bwtraceboundary(edgesWG,WMStart,dirWG,8,WGSize);

IgnoreMask=[];
end
