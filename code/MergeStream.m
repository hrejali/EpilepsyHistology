%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 27th,2018
%Title: Merge list of streams based on the GM start points
function [streams]= MergeStream(streams1,streams2,seg)
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
%% ........................ Boundary Extraction .........................
se = strel('sphere',1);
edgesGB = imdilate(seg==3,se) & seg==1;
edgesIgnore = (imdilate(seg==4,se) & seg==1);

[GMStartpts(:,1), GMStartpts(:,2)]=ind2sub(size(edgesGB),find(edgesGB==1));
[IgnoreStartpts(:,1), IgnoreStartpts(:,2)]=ind2sub(size(edgesIgnore),find(edgesIgnore==1));

%% ....................... Sort Boundary Points ..........................
[GMStartpts, ~,IgnoreMask]=SortSeedSub(seg); % sorts the boundary subscripts

%% ................... Reverse Order for Streamline ......................
sz1=size(streams1);

for i=1:sz1(2)
    temp=streams{1,i}';
    temp=fliplr(temp)'; % flip the order
    streams{1,i}=temp;
    
end


%% ......................... MERGE DATA ..................................
%Note to delete cell must use () instead {} 
i=1;
while(~isempty(streams1) && ~isempty(streams2))
    s1=streams1{1};s2=streams2{1};% always pick the first stream
    % note orders are swaped from order of startpts
    row1=round(s1(1,2));col1=round(s1(1,1)); % row and col streamline1 WM
    row2=round(s2(1,2));col2=round(s2(1,1)); % row and col streamline2 GM
    rowGM=GBSorted(i,1);colGM=GBSorted(i,2); % row and col of GM startpts

    
    if(~IgnoreMask(i))% Ignore Point, delete invalid streams        
        %check if 8-connected neighbourhood of initial stream point
        %correponds to ignore point
        for dx=-1:1
            for dy=-1:1
                if( row1+dx==rowGM && col1+dy==colGM  )
                    streams1(1)=[]; %delete stream requires regular bracket to delete 
                end
            end
        end
        
    else %Valid Start Point, add points to new list
        drow1=abs(row1-row);dcol1=
        if(streams(i))
            
        else
            
        end
        
    end
    
    
    i=i+1;
end



while(~isempty(streams1))
    
end
while(~isempty(streams2))
    
end



end