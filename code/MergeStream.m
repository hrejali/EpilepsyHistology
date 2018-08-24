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
index=1;% keeps track of the index of new list
szGM=size(GMStartpts);

for i=1:szGM(1)-1
   if(~isempty(StreamWM)) 
       WMStream=StreamWM{1};% always pick the first stream
   end
        
    if(~isempty(StreamGM)) %Valid Start Point, add points to new list
        Merge(index)=StreamGM(1); %#ok<*AGROW>
        Shape=alphaShape([StreamGM{1}(:,1);StreamGM{2}(:,1)],[StreamGM{1}(:,2);StreamGM{2}(:,2)]);
        StreamGM(1)=[];
        index=index+1;
        
        while(Shape.inShape(WMStream(1,:)))
            Merge(index)=StreamWM(1);
            StreamWM(1)=[];
            if(~isempty(StreamWM))
                WMStream=StreamWM{1};
                index=index+1;
            end
        end
        % Add WM Streamlines while "startpoints" of streamlines are within
        % range of neighbouring GM Startpints
%         X=[GMStartpts(i,1) GMStartpts(i+1,1)];Xmax=max(X); Xmin=min(X);
%         Y=[GMStartpts(i,2) GMStartpts(i+1,2)];Ymax=max(Y); Ymin=min(Y);
%         while( isRange( GMStartpts(i,:),GMStartpts(i+1,:),round(WMStream(1,:)) ) && ~isempty(StreamWM) ...
%                 && (WMStream(1,1)<=Xmax || WMStream(1,2)<=Ymax) && (WMStream(1,1)>=Xmin || WMStream(1,2)>=Ymin))
%             Merge(index)=StreamWM(1);
%             StreamWM(1)=[];
%             if(~isempty(StreamWM))
%                 WMStream=StreamWM{1};
%                 index=index+1;
%             end
%         end
        
        
        
    end
    
end




end