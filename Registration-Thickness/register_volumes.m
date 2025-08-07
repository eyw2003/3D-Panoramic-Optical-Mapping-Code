%% initialize and load data

folder = '~/Code/MATLAB/research/POM Paper/LAD#11050321';

CT_seg = niftiread(fullfile(folder, 'prediction_diastole.nii.gz')) > 0.5;
PixelDims =  niftiinfo(fullfile(folder, 'prediction_diastole.nii.gz')).PixelDimensions;

dims = [401, 401, 401];
MapProj = read_binary_volume(fullfile(folder, 'IMG0512-011APDMapProjectedv2'), dims);
MapProj(isinf(MapProj)) = -1000;

Sil = load(fullfile(folder, 'IMG0512Silhouette.mat')).SilhouetteFinal;
assert(all(unique(Sil(:)) == [0; 1]))
Sil = logical(Sil);

%% use PCA for basic initial rotations

tform_CT = volume_rotation_transform_pca(CT_seg, true, true);
CT_seg_rot = rotate_volume(CT_seg, tform_CT);

tform_Sil = volume_rotation_transform_pca(logical(Sil), [], true);
Sil_rot = rotate_volume(logical(Sil), tform_Sil);

tform_MapProj = volume_rotation_transform_pca(MapProj ~= -1000, [], true);
MapProj_rot = rotate_volume(MapProj, tform_Sil, 'nearest');

%% save/load rotation transformations

if exist(fullfile(folder, 'tforms.mat'), 'file')
    load(fullfile(folder, 'tforms.mat'));
else
    save(fullfile(folder, 'tforms.mat'), 'tform_CT', 'tform_Sil');
end

CT_seg_rot = rotate_volume(CT_seg, tform_CT);
Sil_rot = rotate_volume(Sil, tform_Sil);
MapProj_rot = rotate_volume(MapProj, tform_Sil, 'nearest');

clear CT_seg Sil MapProj

%% Coregistration from control points

DualOrthoViewer(uint8(Sil_rot), uint8(CT_seg_rot))

%% Load transform created by DualOrthoViewer

[f,p] = uigetfile();
tform_data = load(fullfile(p,f)); % get saved transform
tinit = affinetform3d(tform_data.tform);

clear f p

%% Visualize transformation

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(CT_seg_rot, 'Parent', vwr);
volshow(Sil_rot, 'Parent', vwr, 'Colormap', [0,0,0;1,0,0], 'Transformation', tinit);

%% Manually adjust transformation (if necessary)
% note: will save "tfinal" variable to workspace
app = AdjustCoRegVols(Sil_rot, CT_seg_rot, tinit, 'MaxAlpha', 0.02);

% tfinal = tinit; % just run this if no adjustment desired

%% save/load coregistration transformation

if exist(fullfile(folder, 'final.mat'), 'file')
    load(fullfile(folder, 'final'));
else
    save(fullfile(folder, 'final'), 'tfinal', 'CT_seg_rot', 'Sil_rot', ...
        'SilPerim_rot', 'MapProj_rot');
end

%% transform silhouette volume with transformation we calculated

CT_ref = imref3d(size(CT_seg_rot));
Sil_tformed = imwarp(Sil_rot, imref3d(size(Sil_rot)), tfinal, 'nearest', 'OutputView', CT_ref);
MapProj_tformed = imwarp(MapProj_rot, imref3d(size(MapProj_rot)), tfinal, 'nearest', 'OutputView', CT_ref);

%% Now transfer POM data to CT

CT_seg_POM = transform_and_project(MapProj_rot, CT_seg_rot, tfinal, ...
    'MovingDataLimits', [0, 100], 'MissingValue', 0, ...
    'DistanceThreshold', 20, 'Neighbors', 20);

%% Show POM as "overlay" data on CT

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(CT_seg_rot, 'Parent', vwr, 'Alphamap', linspace(0, 0.2, 256), ...
    'OverlayData', CT_seg_POM, 'OverlayColormap', jet, 'OverlayDataLimits', [0, 100], 'OverlayAlphamap', 0.5);

 