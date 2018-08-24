function [StreamFilt]= StreamFilt(Seg,Stream)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 16th,2018
%Title: Profile Filtering
%% ............................Description................................
% StreamFilt(ImgSeg,Profile)
% Streamlines may end beyon the domain of the laplace solution (beyond GM
% region), therefore we use the segmented image (ImgSeg) to mask out
% regions in which the points of streamline is out of range

%Inputs:
% 1) <Seg>: Segmented image assuming labels are as follows: GM==1, WM==2
% Background==3 and Ignore==4
% 2) <Stream>: Single Profile or Streamline obtained from the segmented image

%Outputs
% 1) <StreamFilt>: Filtered out Streamline by masking out points outside
% of GM region
%% ...........................Initialize Variables........................
%check if cell array
if(iscell(Stream))
    Stream=cell2mat(Stream); % convert to matrix
end
len=size(Stream);
%% ...............................Mask values.............................
% Check if x y coordinates of the streamline fall outside of GM region
for(i=1:len(1))
    vec=Stream(i,:); 
    x=vec(1);y=vec(2);
    if(Seg(round(y),round(x))==1)
    %if(round(interp2(Seg,x,y,'linear'))==1)
        StreamFilt(i,:)=Stream(i,:);

    else
        %Assumption that after the first point outside the boundary
        % correspond to garbage data
        break;
    end
end


%% Filter points strictly extending outside the GM Region 
[x,y]=find(Seg==1);
GMShape=alphaShape(x,y);
index=GMShape.inShape(StreamFilt(:,2),StreamFilt(:,1));
StreamFilt=[StreamFilt(index,1),StreamFilt(index,2)];

sz=size(StreamFilt);
%convert back to cell
StreamFilt=mat2cell(StreamFilt,sz(1),sz(2));

end