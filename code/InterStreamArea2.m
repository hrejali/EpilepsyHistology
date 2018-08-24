%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: June 22nd,2018
%Title: Bewteen Streamline Area
function [List]= InterStreamArea2(Stream,numBins)
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
[Fx,Fy]=ParameterizeStream(Stream); % Fx,y(streamline index, percentage depth [0 1])

%% .........................  Bin Preperation .............................
binloc=-floor(numBins/2):floor(numBins/2); %bin location
binloc(binloc==0)=[];
%% ......................... Area Calculation .............................
stepsize=1/1000;
index=1;
List=struct;
List.StepSize=stepsize;

for i=1:NumStream-1
    index=1;Area=[];
    TotalArea=[];
    for j=1:numBins-1
        List.Stream(i).X=[];List.Stream(i).Y=[];
        
        for k=0:stepsize:1
            List.Stream(i).X=[List.Stream(i).X Fx(i,k)];
            List.Stream(i).Y=[List.Stream(i).Y Fy(i,k)];
            if(k==0)
                Area(index,j)=0;
                TotalArea(index,j)=sum(Area(1:index,j));
                index=index+1;
                continue;
            end
            % Find Coordinates at location of current stream and binloc(j)
            % from current stream
            X=[Fx(i,k) Fx(i,k-stepsize) Fx(i+binloc(j),k) Fx(i+binloc(j),k-stepsize)];
            Y=[Fy(i,k) Fy(i,k-stepsize) Fy(i+binloc(j),k) Fy(i+binloc(j),k-stepsize)];
            
            %Area Calculation
            Area(index,j)=polyarea(X,Y);
            TotalArea(index,j)=sum(Area(1:index,j),'omitnan');
            index=index+1;
        end
        %normalize TotalArea by the sum of the column
        TotalArea(:,j)=TotalArea(:,j)/sum(Area(:,j)); 
        index=1;Area=[];
    end
    
    List.Stream(i).Area=sum(TotalArea,2,'omitnan');
    List.Stream(i).Area(:)= List.Stream(i).Area(:,1)/List.Stream(i).Area(1/stepsize+1,1);
    
end

end