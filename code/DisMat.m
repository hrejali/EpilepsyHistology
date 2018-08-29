%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: August 29th,2018
%Title: Profile Dissimilarity Matrix
function [Mat]=DisMat(X)
%% ............................ Description ...............................
% DisMat(X)
% Algorithm will calculate Disimilarity coeficient bewteen every
% combination of profiles in "Profiles". Disimilarity is calculated from
% the Feature Vector obtained from ExtractFeat using Malhanobis Distance. 

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
% 1) <X>: Structure that contains Feature Vectors of all Profiles
%Outputs:
% 1) <Mat>: Dissimalarity Matrix.
%% .............. Calculate Mahalonobis Distance Bewteen Profiles.........
sz=size(X);
Mat=ones(sz(1),sz(1));
for i=1:sz(1)
    for j=1:sz(1)
      C=cov(X(i,:),X(j,:));
      Cinv=inv(C);
      
      A=(X(i,:)-X(j,:))';
      B=(X(i,:)-X(j,:));
      
      Mat(i,j)=abs((1/C(1,2))*dot(A,B));
      
    end
end



end