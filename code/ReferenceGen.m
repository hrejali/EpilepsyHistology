%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: August 2nd,2018
%Title: Reference Generator
function [Reference]=ReferenceGen(SmoothProfile)
%% ............................ Description ...............................
% ReferenceGen(SmoothProfile)

% Algoirithm will extract average characteristics from SmoothProfile set
% and artificially create a reference 

%% ........................ Initialization ..............................
sz=size(SmoothProfile);
WdtSorted=nan(3,sz(2));
LayerPksLoc=nan(3,sz(2));
AmpSorted=nan(3,sz(2));
%% ..................... Find Peak Characteristics .......................
for i=1:sz(2)
    [pks,loc,Wdt]=findpeaks(SmoothProfile(:,i)); % find peak intensity and location
    pksSorted=sort(pks,'descend');
    
    % find location of most prominent peaks (3 layers of cortex)
    for k=1:3
        try
            LayerPksLoc(k,i)=loc(pks==pksSorted(k));
            WdtSorted(k,i)=Wdt(pks==pksSorted(k));
            AmpSorted(k,i)=pksSorted(k);
        catch
            LayerPksLoc(k,i)=nan;
            WdtSorted(k,i)=nan;
            AmpSorted(k,i)=nan;
        end
    end  
    % Sort peaks such that when averaging, average like locations
    [LayerPksLocSorted(:,i) I]=sort(LayerPksLoc(:,i));
    WdtSorted(:,i)=WdtSorted(I,i);
    AmpSorted(:,i)=AmpSorted(I,i);
end
%% ......................... Creating Reference ...........................
x = linspace(1,1000,1000);
RefWdt=mean(WdtSorted,2,'omitnan');
RefPos=mean(LayerPksLocSorted,2,'omitnan');
RefPkAmplitude=mean(AmpSorted,2,'omitnan');

for n = 1:3
    Gauss(n,:) = RefPkAmplitude(n)*exp(-((x - RefPos(n))/RefWdt(n)).^2);
end

Reference = sum(Gauss);
end
