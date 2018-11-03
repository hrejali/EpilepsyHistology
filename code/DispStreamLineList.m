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
s=streamline(Streamline);
ColorMat=[1 1 0]; %yellow
for i=list
    s(i).Color=ColorMat;
    s(i).LineWidth=3;
end

end