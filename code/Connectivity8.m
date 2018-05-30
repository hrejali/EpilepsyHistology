%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 30th,2018
%Title: 8 connectivity 
function [bool,P]= Connectivity8(P1,P2) 
%% ............................Description................................
%Connectivity8(P1,P2)
% Determines if P2 is within the 8 neighbours of P1 

%              | r-1,c-1 | r-1,c | r-1,c+1 |
%              |  r,c-1  |P1(r,c)| r,c+1   |
%              | r+1,c-1 | r+1.c | r+1,c+1 |


%Inputs:
% 1) <P1>: P1 is foreground pixel (row,col) of interest
% 2) <P2>: Testing if P2 is within 8 connectivity of P1

%Outputs:
% 1) <bool>: returns 1 if P2 is within the 8 neighbours of P1 and 0
% otherwise
% 2) <bool>: returns which neighbour P2 is in if 8 connected, empty
% otherwise
%% .......................8 Connectivity Check............................
bool=0;
P=[];

for dr=-1:1
    for dc=-1:1
        %check if within neighbouring region
        if(P1(1)+dr==P2(1) && P1(2)+dc==P2(2))
            bool=1;
            P=[P1(1)+dr P1(2)+dc];
            break;
        end
    end
end

end

