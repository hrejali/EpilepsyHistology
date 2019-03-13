function DispStreamlineThickness(Comp)
[~,numStream]=size(Comp.Streams);
Thickness=getCorticalThickness(Comp(1).Streams);
Thickness=smooth(Thickness,100);
figure;plot(Thickness);
figure;
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