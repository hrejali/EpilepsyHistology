%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: August 29th,2018
%Title: Extract Features
function [X]=ExtractFeat(Profiles)
%% ............................ Description ...............................
% ExtractFeat(Profiles)
% Program will extract features that describe the shape of individual profiles. 
% Profile shape is quantified using a set of 10 features described by 
% Shleicher et al., 1998 (Observer-Independent Method for Microstructural
% Parcellation of Cerebral Cortex: A Quantitative Approach to
% Cytoarchitectonics )

% Feature Extracted:
% 1) Mean Amplitude 2) Derivative (m0) -- Mean
% 3) Momement1 (m1) 4) Derivative (m1) -- Variance
% 5) Momement2 (m2) 6) Derivative (m2) -- Skewness
% 7) Momement3 (m3) 8) Derivative (m3) -- Kurtosis
% 9) Momement4 (m4)10) Derivative (m4) -- Hyperskewness	

% NOTE: All the moments are computed using a divisor of n rather than 
% n – 1, where n is the length of the vector (as outlined in moment
% documentation)
 
% NOTE: We are only intrested in the absolute value of the first derivative
% (differential quotient) 

%Inputs:
% 1) <Profile>: Entire Profile Set
%Outputs:
% 1) <XStruct>: Structure that contains Feature Vectors of all Profiles
%% ............ Extract Feature Vector for Individual Profiles ...........
sz=size(Profiles);
X=[];
for i=1:sz(2)
    % Extract Mean Amplitude and Derivative
    m0=mean(Profiles(:,i));
    dm0=mean(abs(diff(Profiles(:,i))));
    
    % Extract Variance and Derivative Var
    m1=moment(Profiles(:,i),2);
    dm1=moment(abs(diff(Profiles(:,i))),2);
    
    % Extract Skewness and Derivative
    m2=moment(Profiles(:,i),3);
    dm2=moment(abs(diff(Profiles(:,i))),3);
    
    % Extract Kurtosis and Derivative 
    m3=moment(Profiles(:,i),4);
    dm3=moment(abs(diff(Profiles(:,i))),4);
        
    % Extract Hyperskewness and Derivative 
    m4=moment(Profiles(:,i),5);
    dm4=moment(abs(diff(Profiles(:,i))),5);
    
    temp=[m0 m1 m2 m3 m4 dm0 dm1 dm2 dm3 dm4];
    X=[X;temp]; % Each new row corresponds to an individual Profile
    
end

%% ................ Calucluate the Z score for Each Feature .............
for i=1:10
    X(:,i)=zscore(X(:,i));
end


end