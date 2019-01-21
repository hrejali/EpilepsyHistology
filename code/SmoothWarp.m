function [WarpingSmoothed]=SmoothWarp(Warping,sigma,w)

sz = w;    % length of gaussFilter vector
x = linspace(-sz / 2, sz / 2, sz);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
h = gaussFilter;

[~,NumSeg,~]=size(Warping);
for i=1:NumSeg
    WarpingPad(:,i)=padarray(Warping(:,i,1)',[0,round(w/2)],'symmetric');
    temp=conv(WarpingPad(:,i),h,'same');
    WarpingSmoothed(i,:)=temp(w/2+1:length(temp)-w/2);
end
WarpingSmoothed=round(WarpingSmoothed');
WarpingSmoothed(:,:,2)=Warping(:,:,2);
end