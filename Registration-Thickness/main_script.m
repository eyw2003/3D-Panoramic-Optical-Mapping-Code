%% POM-Thickness Comparison

%% 1 Coregister CT and POM geometries

%% 1.0 Initalize workspace and working directory

clear

%% 1.1 Initialize and load data

folder = 'Example LAD#11';
assert(exist(folder, 'dir'), 'Could not find directory with files!')

CT_seg = niftiread(fullfile(folder, 'prediction_diastole.nii.gz')) > 0.5;
PixelDims =  niftiinfo(fullfile(folder, 'prediction_diastole.nii.gz')).PixelDimensions;

dims = [401, 401, 401];
MapProj = read_binary_volume(fullfile(folder, 'IMG0512-011APDMapProjectedv2'), dims);
MapProj(isinf(MapProj)) = -1000;

Sil = load(fullfile(folder, 'IMG0512Silhouette.mat')).SilhouetteFinal;
assert(all(unique(Sil(:)) == [0; 1]))
Sil = logical(Sil);

%% 1.2 Perform pre-processing of CT and optical mapping volumes so they are roughly oriented 

%% 1.2.1 Use principal component analysis (PCA) for initial rotation "guesses"

tform_CT = volume_rotation_transform_pca(CT_seg, true, true);
CT_seg_rot = rotate_volume(CT_seg, tform_CT);

tform_Sil = volume_rotation_transform_pca(logical(Sil), [], true);
Sil_rot = rotate_volume(Sil, tform_Sil);

% assume same geometry for POM silhouette and map
MapProj_rot = rotate_volume(MapProj, tform_Sil, 'nearest');

%% 1.2.2 Save initial rotation transformations (but don't overwrite)

assert(~exist(fullfile(folder, 'tforms.mat'), 'file'), 'Cannot overwrite "tforms.mat"!');
save(fullfile(folder, 'tforms.mat'), 'tform_CT', 'tform_Sil');

%% 1.2.3 Load existing rotation transformations

assert(exist(fullfile(folder, 'tforms.mat'), 'file'), '"tforms.mat" does not exist!');
load(fullfile(folder, 'tforms.mat'));

CT_seg_rot = rotate_volume(CT_seg, tform_CT);
Sil_rot = rotate_volume(Sil, tform_Sil);
MapProj_rot = rotate_volume(MapProj, tform_Sil, 'nearest');

%% 1.3 Coregister pre-processed CT and POM volumes

%% 1.3.1 Select anatomic control points in GUI

DualOrthoViewer(uint8(Sil_rot), uint8(CT_seg_rot), ...
    'SaveDir', fullfile(folder, 'RegistrationOutput'));

reg_files = dir(fullfile(folder, 'RegistrationOutput', 'reg3d*.mat'));
[~,imax] = max([reg_files.datenum]);

tform_data = load(fullfile(reg_files(imax).folder, reg_files(imax).name)); % get latest saved transform
tfinal = affinetform3d(tform_data.tform);

%% 1.3.2 Manually adjust transformation (if necessary)
% note: will save "tfinal" variable to workspace

app = AdjustCoRegVols(Sil_rot, CT_seg_rot, tfinal, 'MaxAlpha', 0.02);

%% 1.3.3 Save final coregistration transformation (but don't overwrite)

assert(~exist(fullfile(folder, 'final.mat'), 'file'), 'Cannot overwrite "final.mat"!');
save(fullfile(folder, 'final'), 'tfinal');

%% 1.3.4 Load final coregistration transformation

assert(exist(fullfile(folder, 'final.mat'), 'file'), '"final.mat" does not exist!');
load(fullfile(folder, 'final.mat'));

%% 1.3.5 Visualize coregistration transformation

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(CT_seg_rot, 'Parent', vwr);
volshow(Sil_rot, 'Parent', vwr, 'Colormap', [0,0,0;1,0,0], 'Transformation', tfinal);

%% 1.4 Coregister pre-processed CT and POM volumes

%% 1.4.1 Perform transformation on POM Silhouette

CT_ref = imref3d(size(CT_seg_rot));
Sil_tformed = imwarp(Sil_rot, imref3d(size(Sil_rot)), tfinal, 'nearest', 'OutputView', CT_ref);
MapProj_tformed = imwarp(MapProj_rot, imref3d(size(MapProj_rot)), tfinal, 'nearest', 'OutputView', CT_ref);

%% 1.4.2 After transforming POM geometry, directly transfer POM data to CT

CT_seg_POM = transform_and_project(MapProj_rot, CT_seg_rot, tfinal, ...
    'MovingDataLimits', [0, 100], 'MissingValue', 0, ...
    'DistanceThreshold', 20, 'Neighbors', 20);

%% 1.4.3 Show POM as "overlay" data on CT

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(CT_seg_rot, 'Parent', vwr, 'Alphamap', linspace(0, 0.2, 256), ...
    'OverlayData', CT_seg_POM, 'OverlayColormap', jet, 'OverlayDataLimits', [0, 100], 'OverlayAlphamap', 0.5);

%% 2 Extract micro CT wall thickness

%% 2.1 Crop unused background voxels and "filter" (smooth) volume

[CT_seg_cropped, cropInds] = crop_volume(CT_seg_rot);
CT_seg_filtered = imgaussfilt3(double(CT_seg_cropped), 3) > 0.5;
CT_seg_filtered = extract_largest_component(CT_seg_filtered, 'Connectivity', 6);

% fill internal cavities
CT_seg_filtered = ~extract_largest_component(~CT_seg_filtered);

%% 2.2 Generate visualization with cube for scale

PixelsPerMM = round(1 ./ PixelDims);

[rr,cc,pp] = ndgrid(1:size(CT_seg_filtered,1), 1:size(CT_seg_filtered,2), ...
    1:size(CT_seg_filtered, 3));
cube = (size(CT_seg_filtered,1) + 1 - rr) <= PixelsPerMM(1) ...
    & cc <= PixelsPerMM(2) & pp <= PixelsPerMM(3);

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(imgaussfilt3(double(CT_seg_cropped), 3) > 0.5 | cube, 'Parent', vwr)

%% 2.3 Extract CT wall thickness

%% 2.3.1 Generate version of CT with interior voxels filled

CT_seg_filled = fill_volume_slicewise(CT_seg_filtered);

% make sure all voxels in "filtered" are also in "filled"
assert(~any(CT_seg_filtered & ~CT_seg_filled, 'all'));

%% 2.3.2 Identify epicardium and endocardium

% First, extract boundary of filtered CT -> includes endocardium and epicardium
perim = bwperim(CT_seg_filtered, 26);

% Next, extract boundary of "filled" CT -> includes just epicardium
filled_perim = bwperim(CT_seg_filled, 26);

% Calculate (Euclidean) distances to epicardium
filled_perim_dists = bwdist(filled_perim);

% Set threshold distance to determine endocardium vs. epicardium
dist_thresh = 5;

% Label endocardium as boundary voxels sufficiently far from epicardium
endo = extract_largest_component(perim & (filled_perim_dists > dist_thresh));

% Label non-endocardium boundary voxels as epicardium
epi = perim & ~endo;

% Show segmented endo/epicardium
vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(endo, 'Parent', vwr, 'Colormap', [0,0,0.75])
volshow(epi, 'Parent', vwr, 'AlphaMap', linspace(0, 0.1, 256))     

%% 2.3.3 Perform distance transform

% Calculate voxel-wise distances from endocardium
endo_dist_map = bwdist(endo);

% Convert voxels to mm
endo_dist_map_mm = endo_dist_map * PixelDims(1); % convert pixels -> mm

%% 2.3.4 Show final distances on CT volume

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(endo_dist_map_mm, 'Colormap', parula, 'DataLimits', [0,2], ...
    'AlphaData', CT_seg_filtered, 'Parent', vwr);



 