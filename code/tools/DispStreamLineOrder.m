%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 5th,2018
%Title: Display Streamline Order 
function DispStreamLineOrder(Streamline)
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

increment=1/round(sz(2)/3);
ColorMat=[0 0 0];
index=1;
for i = 1:3
    for j=1:round(sz(2)/3)
        try
            s(index).Color=ColorMat;
            ColorMat(i)=ColorMat(i)+increment;
            if(ColorMat(i)>1.0)
                ColorMat(i)=1;
            end
        catch
            break
        end
        index=index+1;
    end
    
end
try
    if(mod(sz(2)/3,1)>0)
        s(index).Color=ColorMat;
    end
catch
    
end
end