function [streamlines]= ProfileComp(Image_dir)
%Image_dir='~/Documents/Projects/EpilepsyProject/Segmentation/EPI_P040_Neo_06_NEUN_Seg2.nii.gz';
%%
%...............................Import and Check Image Dim............................................... 
ors = load_nii(Image_dir);
if(ndims(orig.img)==2)
    % Makign the 2D image a 3D image to allow the Laplace equation to run 
    orig.img(:,:,2) = zeros(size(orig.img)); 
end
%%

sz = size(orig.img);
fg = find(orig.img==1);
src = find(orig.img==2);
snk = find(orig.img==3);
%%
LPfield = laplace_solver(fg,src,snk,5000,[],sz);

LPfieldImage = orig;
LPfieldImage.img = zeros(sz);
LPfieldImage.img(fg) = LPfield;
LPfieldImage.img(:,:,2) = [];
%save_nii(LPfieldImage, 'test.nii.gz');
%%
figure; hold on
image = zeros(sz(1),sz(2));
image(fg) = LPfield;
image(src) = 0;
image(snk) = 1;
se = strel('sphere',1);
edgesWG = imdilate(orig.img==2,se) & orig.img==1; %this finds start points on the source edge inside the greymatter
edgesGB = imdilate(orig.img==3,se) & orig.img==1; %this finds start points on the forground edge
% [startpts1,startpts2] = ind2sub(size(edgesGB),find(image<0.55 & image>0.45)); %converts start points to list of x y z coordinates
[startpts1,startpts2] = ind2sub(size(edgesWG),find(edgesWG(:,:,1)==1)); %converts start points to list of x y z coordinates
[dx,dy]=gradient(image);
imagesc(image);
% scatter(startpts2,startpts1);
streams1 = stream2(dx,dy,startpts2,startpts1, [1 1000000]); %this returns a list of streamlines, which can be viewed with streamline()
[startpts1,startpts2] = ind2sub(size(edgesGB),find(edgesGB(:,:,1)==1)); %converts start points to list of x y z coordinates
[dx,dy]=gradient(image);
streams2 = stream2(-dx,-dy,startpts2,startpts1, [1 1000000]); %this returns a list of streamlines, which can be viewed with streamline()
s1=streamline(streams1);
s2=streamline(streams2);

end


