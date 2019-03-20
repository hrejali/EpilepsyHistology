%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: March 18th,2018
%Title: get Binned Feature Profile Distances
function [Dist]=InterProfileDistance(MeanProfile,Profiles)
%% Distance bewteen two profiles
len=size(Profiles);

for i=1:len(2)
    %AvgDist=norm(Profiles(:,i)-MeanProfile)+AvgDist;
    Dist(i)=norm(Profiles(:,i)-MeanProfile);
end
