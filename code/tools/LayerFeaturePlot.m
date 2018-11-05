%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: September 19th,2018
%Title: LayerFeaturePlot
function LayerFeaturePlot(LayerSegmentation,FeatureMap,Streamline)
%% ............................ Description ...............................
% ConnectedCompCrop(img,ConnectedComp)

% Algorithm will crop specfied image into multiple components. 
% The connected components are determined from FGConnectedComp algorithm and
% stored in structure obtained from StreamlineComp Algorithm. This function
% will be used to crop Feature Maps into (n) number of components

%Inputs:
% 1) <LayerSegmentation> Croped LayerSegmentation
% 2) <FeatureMap> Croped FeatureMap
% 3) <Streamline> Single Streamline

%% Obtain Profiles From Input 1) & 2)

LayerProfile=SampleStream(LayerSegmentation.Comp.img,Streamline,'nearest');
Profile=SampleStream(FeatureMap,Streamline);

%% Plot Profiles
figure;
plot(Profile);

yMax=max(Profile);
x=find(LayerProfile==1);sz=size(x);
hold on;l=line([x(1) x(1)],[0 yMax]);% Layer 1 start
l.Color = 'red';l.LineStyle = '--';
%hold on;l=line([x(sz(1)) x(sz(1))],[0 yMax]);% Layer 1 end
%l.Color = 'red';l.LineStyle = '--';

x=find(LayerProfile==2);sz=size(x);
hold on;l=line([x(1) x(1)],[0 yMax]);% Layer 2 start
l.Color = 'green';l.LineStyle = '--';
%hold on;l=line([x(sz(1)) x(sz(1))],[0 yMax]);% Layer 2 end
%l.Color = 'green';l.LineStyle = '--';

x=find(LayerProfile==3);sz=size(x);
hold on;l=line([x(1) x(1)],[0 yMax]);% Layer 3 start
l.Color = 'blue';l.LineStyle = '--';
%hold on;l=line([x(sz(1)) x(sz(1))],[0 yMax]);% Layer 3 end
%l.Color = 'blue';l.LineStyle = '--';

x=find(LayerProfile==4);sz=size(x);
hold on;l=line([x(1) x(1)],[0 yMax]);% Layer 4 start
l.Color = 'yellow';l.LineStyle = '--';
%hold on;l=line([x(sz(1)) x(sz(1))],[0 yMax]);% Layer 4 end
%l.Color = 'yellow';l.LineStyle = '--';

x=find(LayerProfile==5);sz=size(x);
hold on;l=line([x(1) x(1)],[0 yMax]);% Layer 5 start
l.Color = 'Cyan';l.LineStyle = '--';
%hold on;l=line([x(sz(1)) x(sz(1))],[0 yMax]);% Layer 5 end
%l.Color = 'Cyan';l.LineStyle = '--';

x=find(LayerProfile==6);sz=size(x);
hold on;l=line([x(1) x(1)],[0 yMax]);% Layer 6 start
l.Color = 'magenta';l.LineStyle = '--';
%hold on;l=line([x(sz(1)) x(sz(1))],[0 yMax]);% Layer 6 end
%l.Color = 'magenta';l.LineStyle = '--';

xlim([0 x(sz(1))]);ylim([0 yMax]);
end