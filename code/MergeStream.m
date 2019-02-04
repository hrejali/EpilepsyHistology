%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 27th,2018
%Title: Merge list of streams based on the GM start points
function [Merge]= MergeStream(StreamWM,StreamGM,seg)
%% ............................Description................................
%MergeStream(streams1,streams2)
% Merges streamline lists into 1 list based on the GM start points.:
% This function segmented image in order to extract requires an inital start point, 
% and ignore points

% Assumes the segmented image has following labels: GM==1, WM==2,
% Background==3, and Ignore mask==4 

%Inputs:
% 1) <streams1>: streamlines from the Grey-WM boundary extraction
% 2) <streams2>: streamlines from the Grey-CSF boundary extraction
% 3) <Seg>: Segmented image: (GM==1,WM==2,Background==3,Ignore maske==4)

%Outputs:
% 1) <streams>: Merged streams sorted based on the GM start points.

%% ....................... Sort Boundary Points ..........................
[GMStartpts, ~,~]=SortSeedSub(seg); % sorts the boundary subscripts
GMStartpts(:,[1 2])=GMStartpts(:,[2 1]); %Note orders are swaped from streamline orders
%% ................... Reverse Order for Streamline ......................
sz1=size(StreamWM);
for i=1:sz1(2)
    temp=StreamWM{1,i}';
    temp=fliplr(temp)'; % flip the order
    StreamWM{1,i}=temp;
    
end

%% ......................... MERGE DATA ..................................
%Note to delete cell must use () instead {}
%delete first 5 WM Streamlines - to ensure GM streamlines start first
StreamWM(1:5)=[];

% Errode Streamlines to ensure proper merge (HACK)
StreamFiltWM=erodeStream(seg,StreamWM);
% Delete any empty list in StreamLineFiltWM and corresponding indicies in
% StreamWM
StreamWM(cellfun(@isempty,StreamFiltWM))=[];
StreamFiltWM(cellfun(@isempty,StreamFiltWM))=[];

% Read First WM Streamline
if(~isempty(StreamFiltWM)) % Maybe Take this out of for loop and have it there
    WMStream=StreamFiltWM{1};% always pick the first stream
end
index=1;% keeps track of the index of new list
szGM=size(GMStartpts);
for i=1:szGM(1)-1

    %% Check for empty GM List and Append     
    if(~isempty(StreamGM)) %Valid Start Point, add points to new list
        
        Merge(index)=StreamGM(1); %#ok<*AGROW>
        index=index+1;
        %% Create Bounding Box Bewteen GM Streamlines -- AlphaShape creates bounding area that envelops a set of 2-D points
        Shape=alphaShape([StreamGM{1}(:,1);StreamGM{2}(:,1)],[StreamGM{1}(:,2);StreamGM{2}(:,2)]);
        Shape.Alpha = criticalAlpha(Shape,'one-region')+0.2; % gives a little leway to avoid holes in strip
        if(Shape.numRegions>1) % In case when Alpha shape produces more than 1 region (Alpha radius not big enough
            Shape=alphaShape([StreamGM{1}(:,1);StreamGM{2}(:,1)],[StreamGM{1}(:,2);StreamGM{2}(:,2)],Shape.Alpha+Shape.Alpha*0.2);
        end
        StreamGM(1)=[];

        %% While WM Streamlines bewteen GM Streamlines Append
        % Use StreamFiltWM to compare and StreamWM to Append to Merge
        while( (Shape.inShape(WMStream(1,:))) && ~isempty(StreamFiltWM) )
            Merge(index)=StreamWM(1);
            StreamWM(1)=[];
            StreamFiltWM(1)=[];
            % Update WMStream 
            if(~isempty(StreamFiltWM))
                WMStream=StreamFiltWM{1};
                index=index+1;
            end
        end

    end
    
end




end
