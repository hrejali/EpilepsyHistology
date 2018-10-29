% Layer 4 Segmentation
sz=size(AlignedProfiles_NeuronDensity2);
%Find the Average profile from Aligned Profiles
AvgProfile_NeuronDensity=AverageProfilePlot(AlignedProfiles_NeuronDensity2);
AvgProfile_NeuronSize=AverageProfilePlot(AlignedProfiles_NeuronSize2);
% Find the most prominent peak location Layer 4
[pks,locs,~] = findpeaks(AvgProfile_NeuronDensity);
L4_ind=find(pks==max(pks));
L4_loc=locs(L4_ind);

% Find the peak location Layer 3 & 5
[pks,locs,~] = findpeaks(AvgProfile_NeuronSize);
L3_loc=min(locs);
L5_loc=max(locs);

w34=abs((L3_loc-L4_loc)/2);
w45=abs((L5_loc-L4_loc)/2);

%Define Layer 4 
Layer4=zeros(sz(1),sz(2));
Layer4(L4_loc-w34:L4_loc+w45,:)=1;
figure;imagesc(Layer4);