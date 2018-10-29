%Name: Hossein Rejali
%Supervisor: Dr. Ali Khan
%Date: October 10 th,2018
%Title: cow_inv_apply
function [Pinv]=cow_inv_apply(Profiles,WarpingStruct)
%cow_inv_apply(Profiles,WarpingStruct)

%Inputs:
% 1) <Profiles> Set of Profiles 
% 2) <WarpingStruct> interpolation segment starting points
%          after warping (first slab) and before warping (second slab)
%Outputs:
%1) <Pinv> Inverse Profiles with inverse transformations obtained from WarpingStruct

%% Initialization
sz=size(Profiles);
numTransforms=length(WarpingStruct);
Pinv=Profiles;
X=1:sz(1);
%% Obtaining Inverse Transform and Applying Transformation 
for i=numTransforms:-1:1
    % Run through each streamline and apply inverse transform
    for j=1:sz(2)
        % Create transformation function
        pp=interp1(WarpingStruct(i).SmoothTransforms(j,:,1),WarpingStruct(i).SmoothTransforms(j,:,2),'linear','pp');
        % plot transfer function
        %figure;plot(ppval(pp,1:1000));
        %Find Query points and evaluate them
        Xquery=ppval(pp,1:sz(1));
        Pinv(:,j)=interp1(X,Pinv(:,j),Xquery);
    end
end
figure;surf(Pinv);shading flat; title('Inverted Profiles - Area Space')
figure;surf(Profiles);shading flat;title('Aligned Profiles - Aligned Space')
end