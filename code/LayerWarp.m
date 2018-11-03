%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: September 24th,2018
%Title: ConnectedCompCrop
function [AlignedLayers]=LayerWarp(LayerProfiles,WarpSegmentLoc)
%% ............................ Description ...............................
% LayerWarp(LayerProfiles,Warping)

% Will warp the Layer Profiles based on the Warping Output from Correlation
% optimized warping (COW) algoirthm.

% n = # points in profile (1000)
% m = # of profiles
% N = # of segments

%Inputs:
% 1) <LayerProfile> (n x m)
% 2) <Warping> (m x N x 2) interpolation segment starting points (in "nP"
%          units) after warping (first slab) and before warping (second slab)
%          (difference of the two = alignment by repositioning segment
%          boundaries; useful for comparing correction in different/new objects/samples)

%Outputs:
% 2) <AlignedLayers> (n x m): Aligned Layer Profiles
%% ......................... Initialization ...............................
[~,NumProfiles]=size(LayerProfiles);
[~,NumSegments,~]=size(WarpSegmentLoc);
SegmentLoc=WarpSegmentLoc(:,:,2); WarpSegmentLoc(:,:,2)=[];
AlignedLayer=[];Segment=[];
%% ......................... Layer Profile Warping .......................
for i=1:NumProfiles
    for j=1:NumSegments-1
        %% Update Variables
        PostLoc=SegmentLoc(i,j+1);PostLocPrime=WarpSegmentLoc(i,j+1);
        Loc=SegmentLoc(i,j);LocPrime=WarpSegmentLoc(i,j);
        
        %% Extract Original Segment
        Segment=LayerProfiles(Loc:PostLoc,i);
        SegLength=length(Segment);
        WarpSegLength=PostLocPrime-LocPrime;
        if(j==1)
            WarpSegLength=WarpSegLength+1;
        end
        %% Add or Delete Points to original segment
        if(WarpSegLength>SegLength)
            % add points
            diff=abs(SegLength-WarpSegLength);
            pts=ones(1,diff)*double(Segment(end));% take last point and replicate it to add to original segment
            Segment=[Segment',pts]';
        else
            % delete points
            diff=abs(SegLength-WarpSegLength);
            Segment=Segment(1:end-diff);
        end
        
        AlignedLayer=[AlignedLayer;Segment];
 
    end
    AlignedLayers(:,i)=AlignedLayer';
    AlignedLayer=[];
end
end
       
        
    