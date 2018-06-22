%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 13th,2018
%Title: Number of Decimal Point
function [num]= NumDecimal(dec)

num=0;
while (floor(dec*10^num)~=dec*10^num)
    num=num+1;
end

end