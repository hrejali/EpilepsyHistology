function [Profile, corticalPer] = SampleStream(Img,Stream,Interp)
%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: May 16th,2018
%Title: Sample Intensities from Streamlines
%% ............................Description................................
% SampleStream(Img,Stream)
% Sampling intensities from histological slices or MR images. Profiles
% extracted corresponds to the characteristic laminar characterstic or profile
% Depending on the img used (e.g. density of the neurons) the the profiles
% explain how intensities change across the different layer of the cortex

% Assumes that Streamlines correspond to curves produced from the
% StreamLineComp f(x)

%Inputs:
% 1) <Img>: MR or Histological img 
% 2) <Stream>: Single Profile or Streamline obtained from the correponding
% cortical region in the Img image
% 3) <Interp>: Method for interpolating intensity values defualt is 'linear'
% following options are avaliable: 'linear','nearest',','cubic, 'spline'
% Interpolation is done using the interp2 function for more details visit: 
% https://www.mathworks.com/help/matlab/ref/interp2.html

%Outputs:
% 1) <Profile>: Vector that describes the sampled intensities along the
%  streamline

%% .....................Check number of inputs...........................
exist Interp var % check to see if this variable exist!
if (~ans)
    Interp = 'linear'; % set Interpolation as linear (Defualt)
end
if nargin < 2   % if the number of inputs equals smaller than 2 not enough inputs
    msg= 'Not enough inputs -- Required inputs: 1) Image to sample from 2) Streamline to sample the image ';
    error(msg);
end
%% ............. Check type of StreamLine (cell --> mat) ................
if(iscell(Stream))
    Stream=cell2mat(Stream);
end
%% .................Interpolate and Sample Intensities.....................
% Note the flip in x an y, due flip in previous code StreamlineComp
Profile=interp2(Img,Stream(:,1),Stream(:,2),Interp); 
%% ..........Cortical Depth (%) Corresponding to each Sample...............
len=size(Stream);
StartPT=norm(Stream(1,:));
EndPT=norm(Stream(len(1),:));

for i=1:len(1)
corticalPer(i)=(norm(Stream(i,:))-StartPT)/(StartPT-EndPT);
end
corticalPer=abs(corticalPer);
end