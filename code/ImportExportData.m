%% ......................... Import Files ................................
% Note must be connected to eq-nas network to import files
% Layer Segmentation
LayerSegmentation=load_untouch_nii('\\eq-nas.imaging.robarts.ca\EpilepsyHistology\Histology\EPI_P036\100um_Annotations_layers\histspace\layers\EPI_P036_Neo_07_NEUN.nii.gz');

% Feature Map
Feature=load_untouch_nii('C:\Users\Hossein\Documents\MASc\Projects\EpilepsyHistology\Output\Features\EPI_P036_Neo_07_NEUN_NeuronDensity.nii.gz');

% Grayscale Image
imgGrayScale=load_untouch_nii('C:\Users\Hossein\Documents\MASc\Projects\EpilepsyHistology\Output\Features\EPI_P036_Neo_07_NEUN_NeuronDensity.nii.gz');

%% ....................... Save as Nifti .................................
Output_dir='C:\Users\Hossein\Documents\MASc\Projects\EpilepsyHistology\Output';
SubjId='EPI_P037_Neo_08_NEUN';
Res='100um';
%Layer Segmentation
%niftiwrite(LayerSegmentation.img,[Output_dir,'\Segmentation\',SubjId,'_',Res,'_LayerSegmentation']);

%src-snk Segmentation
niftiwrite(uint8(LayerSegmentation.img>0),[Output_dir,'\Segmentation\','_',Res,SubjId,'_Seg']);

% Feature Map ( just the NeuronDensity
%niftiwrite(Feature.featureVec(:,:,1),[Output_dir,'\Features\',SubjId,'_',Res,'_NeuronDensity']);

% GrayScale
%niftiwrite(imgGrayScale.featureVec,[Output_dir,'\Grayscale\',SubjId,'_',Res,'_Grayscale']);

