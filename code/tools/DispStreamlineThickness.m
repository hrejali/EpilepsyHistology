function [fig]=DispStreamlineThickness(Comp)
[~,numStream]=size(Comp.Streams);
Thickness=getCorticalThickness(Comp(1).Streams);
%% Plotting Thickness Measure
% figure;subplot(1,2,1);plot(Thickness);title('Original Thickness');
% Thickness=smooth(Thickness,100);subplot(1,2,2);
% plot(Thickness);title('Smoothed Thickness');

%% Overlay Thickness Measure on Individual Streamlines
fig=figure;
for Depth=0:0.01:1
    X=[];Y=[];
    for i=1:numStream
        X=[X Comp(1).Depth.F.Fx(i,Depth)];
        Y=[Y Comp(1).Depth.F.Fy(i,Depth)];
    end
    scatter(X,Y,0.5,Thickness);
    hold on;
end
end