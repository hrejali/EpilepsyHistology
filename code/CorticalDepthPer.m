function [corticalPer]= CorticalDepthPer(Stream)
% Will give a vector containing cortical depth as a percentage at each
% particular coordinate in the streamline

% <Streamline>: Streamline
% <corticalPer>: Vector containing how far from the cortical surface (GM)
% the cordinate is as a percentage
len=size(Stream);
StartPT=norm(Stream(1,:));
EndPT=norm(Stream(len(1),:));

for i=1:len(1)
corticalPer(i)=(norm(Stream(i,:))-StartPT)/(StartPT-EndPT);
end
corticalPer=abs(corticalPer);

end