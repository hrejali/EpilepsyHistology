%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 30th,2018
%Title: isRange 
function [bool]= isRange(P1,P2,P) 
%%
%isRange(P1,P2,P)
% Checks if point P lies within the limits or boundary of points P1 and P2

%Inputs:
% 1) <P1>: P1 is first point with a specified row and col indicating
% location of P1
% 2) <P2>: P2 is second point with specified row and col indicating
% location of P2
% 3) <P>: P is the point under investigation, want to check if P is withing
% the boundary made by P1 and P2 

%Outputs:
% 1) <bool>: returns 1 if P is within the boundary and 0 otherwise

%% .......................Find Upper and Lower Limits.....................
if(P1(1)>P2(1))
    UpperlimR=P1(1);
    LowerlimR=P2(1);
else
    UpperlimR=P2(1);
    LowerlimR=P1(1);
    
end

if(P1(2)>P2(2))
    UpperlimC=P1(2);
    LowerlimC=P2(2);
else
    UpperlimC=P2(2);
    LowerlimC=P1(2);
    
end
%% ....................Determine if point lies within range...............
bool=0;
if( (P(1)>=LowerlimR && P(1)<=UpperlimR) && (P(2)>=LowerlimC && P(2)<=UpperlimC) )
   bool=1; 
end

end