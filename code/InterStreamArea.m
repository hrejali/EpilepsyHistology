%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 22nd,2018
%Title: Bewteen Streamline Area
function [List]= InterStreamArea(Stream)
%% ............................ Description ...............................
% InterStreamArea(Stream)
% Calculate the area made bewteen neighbouring streamlines at (i,j)
% (i+1,j), (i,j+1), (i+1,j+1) cordinates where i indexes the particular
% streamline and j indexes the points on the stream line

% Fx( Streamline index (i), % depth (j) )
% Fy( Streamline index (i), % depth (j) )

%Inputs:
% 1) <Img>: MR or Histological img 
% 2) <Stream>: Merged Streamlines obtained from the correponding
% cortical region in the Img image

%Outputs:
% 1) <List>: List of areas for all streamlines

%% ....... Reparameterize Streamlines by Cortical Depth Percentage ........
NumStream=length(Stream);
[F,~]=ParameterizeStream(Stream); % Fx,y(streamline index, percentage depth [0 1])
Fx=F.Fx; Fy=F.Fy;
%% ......................... Area Calculation .............................
stepsize=1/1000;
List=struct;
List.StepSize=stepsize;

for i=1:NumStream-1
    index=1;
    List.Stream(i).X=[];List.Stream(i).Y=[];
        
        for k=0:stepsize:1
            List.Stream(i).X=[List.Stream(i).X Fx(i,k)];
            List.Stream(i).Y=[List.Stream(i).Y Fy(i,k)];
            if(k==0)
                Area(index,i)=0;
                TotalArea(index,i)=sum(Area(1:index,i));
                index=index+1;
                continue;
            end
            % Find Coordinates at location of current stream and binloc(j)
            % from current stream
            X=[Fx(i,k) Fx(i,k-stepsize) Fx(i+1,k) Fx(i+1,k-stepsize)];
            Y=[Fy(i,k) Fy(i,k-stepsize) Fy(i+1,k) Fy(i+1,k-stepsize)];
            
            %Area Calculation
            Area(index,i)=polyarea(X,Y);
            TotalArea(index,i)=sum(Area(1:index,i));
            index=index+1;
        end
        %normalize TotalArea by the sum of the column
        TotalArea(:,i)=TotalArea(:,i)/sum(Area(:,i));
        
end
%% ....................... Guassian Smoothing ............................
w = 100;
sigma = 50;
sz = w;    % length of gaussFilter vector
x = linspace(-sz / 2, sz / 2, sz);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
h = gaussFilter;

for i=1:1/stepsize+1
    TotalAreaPad(i,:)=padarray(TotalArea(i,:),[0,round(w/2)],'symmetric');
    temp=conv(TotalAreaPad(i,:),h,'same');
    TotalAreaFilt(i,:)=temp(w/2+1:length(temp)-w/2);
end
%% Store into Struct
for i =1:NumStream-1
    List.Stream(i).Area=TotalAreaFilt(:,i);
end

end