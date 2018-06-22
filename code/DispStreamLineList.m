%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 5th,2018
%Title: Display Streamline list 
function DispStreamLineList(Streamline,list)
%% ............................Description................................
% DispStreamLineOrder(Streamline)
% Display the order the Streamline

%Inputs:
% 1) <Streamline>: Streamlines  

%Outputs:
% 1) Figure of streamlines with increasing order of streamline shown with
% different color.
%%
sz=size(Streamline);
s=streamline(Streamline);
ColorMat=[1 1 0]; %yello
for i=list
    s(i).Color=ColorMat;
end
end