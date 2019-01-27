%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: Jan 27th,2019
%Title: Erode StreamLines
function [StreamFilt]= erodeStream(Seg,Streamlines)

se=[0 1 0; 1 1 1; 0 1 0];
se=strel('arbitrary',se);
eSeg=imerode(Seg==1,se);
[x,y]=find(eSeg==1);
GMShape=alphaShape(x,y);

for i=1:length(Streamlines)
    Stream=Streamlines{i};
    index=GMShape.inShape(Stream(:,2),Stream(:,1));
    temp=[Stream(index,1),Stream(index,2)];
    sz=size(temp);
    %convert back to cell
    StreamFilt(i)=mat2cell(temp,sz(1),sz(2));
end
end