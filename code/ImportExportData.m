%% ......................... Import Files ................................
% Note must be connected to eq-nas network to import files
% Layer Segmentation
LayerSegmentation=load('\\eq-nas.imaging.robarts.ca\EpilepsyHistology\Histology\EPI_P040\100um_Annotations_layers\EPI_P040_Neo_08_NEUN.mat');

% Feature Map
Feature=load('\\eq-nas.imaging.robarts.ca\EpilepsyHistology\Histology\EPI_P040\100um_5umPad_FeatureMaps\EPI_P040_Neo_08_NEUN.mat');

% Grayscale Image
imgGrayScale=load('\\eq-nas.imaging.robarts.ca\EpilepsyHistology\Histology\EPI_P040\100um_Grayscale\EPI_P040_Neo_08_NEUN.mat');

%% ....................... Save as Nifti .................................
Output_dir='C:\Users\Hossein\Documents\MASc\Projects\EpilepsyHistology\Output';
SubjId='EPI_P040_Neo_08_NEUN';
Res='100um';
%Layer Segmentation
niftiwrite(LayerSegmentation.featureVec,[Output_dir,'\Segmentation\',SubjId,'_',Res,'_LayerSegmentation']);

%src-snk Segmentation
niftiwrite(uint8(LayerSegmentation.featureVec>0),[Output_dir,'\Segmentation\','_',Res,SubjId,'_Seg']);

% Feature Map ( just the NeuronDensity
niftiwrite(Feature.featureVec(:,:,1),[Output_dir,'\Features\',SubjId,'_',Res,'_NeuronDensity']);

% GrayScale
niftiwrite(imgGrayScale.featureVec,[Output_dir,'\Grayscale\',SubjId,'_',Res,'_Grayscale']);
