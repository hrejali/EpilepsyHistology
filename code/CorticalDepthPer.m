function [corticalPer]= CorticalDepthPer(Stream)
% Will give a vector containing cortical depth as a percentage at each
% particular coordinate in the streamline

% <Streamline>: Streamline
% <corticalPer>: Vector containing how far from the cortical surface (GM)
% the cordinate is as a percentage
len=size(Stream);
if(len(1)<2)
    corticalPer(1)=0;
    return
end
%% ................. Pathlenth and Cortical Depth Calculation ............
for i=1:len(1)
%corticalPer(i)=(norm(Stream(i,:))-StartPT)/(StartPT-EndPT);
corticalPer(i)=Pathlength(Stream(1:i,:));
end
%corticalPer=abs(corticalPer);
corticalPer(:)=corticalPer(:)/corticalPer(len(1)); % divide by entire length
end