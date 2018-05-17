function [StreamFilt]= StreamFilt(Seg,Stream)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 16th,2018
%Title: Profile Filtering
%% ............................Description................................
% ProfileFilt(ImgSeg,Profile)
% Profiles may end beyon the domain of the laplace solution (beyond GM
% region), therefore we use the segmented image (ImgSeg) to mask out
% regions in which the profile is out of range

% 1) <Seg>: Segmented image assuming labels are as follows: GM==1, WM==2
% Background==3 and Ignore==4
% 2) <Stream>: Single Profile or Streamline obtained from the segmented image 
% 3) <StreamFilt>: Filtered out Streamline by masking out points outside
% of GM region
%% ...........................Initialize Variables........................
Stream=cell2mat(Stream); % convert to matrix 
len=size(Stream);
%% ...............................Mask values.............................
% Check if x y coordinates of the streamline fall outside of GM region
for(i=1:len(1))
    vec=Stream(i,:); 
    x=vec(1);y=vec(2);
    if(Seg(round(y),round(x))~=1)
        %Assumption that after the first point outside the boundary 
        % correspond to garbage data
        break; 
       
    else
        StreamFilt(i,:)=Profile(i,:);
    end
end


end