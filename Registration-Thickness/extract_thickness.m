% extract_thickness

%% crop and filter volume

[CT_seg_cropped, cropInds] = crop_volume(CT_seg_rot);
CT_seg_filtered = imgaussfilt3(double(CT_seg_cropped), 3) > 0.5;
CT_seg_filtered = extract_largest_component(CT_seg_filtered, 'Connectivity', 6);

% fill internal cavities
CT_seg_filtered = ~extract_largest_component(~CT_seg_filtered);

%% show scale cube

PixelsPerMM = round(1 ./ PixelDims);

[rr,cc,pp] = ndgrid(1:size(CT_seg_filtered,1), 1:size(CT_seg_filtered,2), ...
    1:size(CT_seg_filtered, 3));
cube = (size(CT_seg_filtered,1) + 1 - rr) <= PixelsPerMM(1) ...
    & cc <= PixelsPerMM(2) & pp <= PixelsPerMM(3);

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(imgaussfilt3(double(CT_seg_cropped), 3) > 0.5 | cube, 'Parent', vwr)

%% extract solid volume

CT_seg_filled = fill_volume_slicewise(CT_seg_filtered);

% make sure all voxels in "filtered" are also in "filled"
assert(~any(CT_seg_filtered & ~CT_seg_filled, 'all'));

%% Obtain epicardium and endocardium from perims of filled and non-filled

perim = bwperim(CT_seg_filtered, 26);
filled_perim = bwperim(CT_seg_filled, 26);

filled_perim_dists = bwdist(filled_perim);

dist_thresh = 5;

endo = extract_largest_component(perim & (filled_perim_dists > dist_thresh));
epi = perim & ~endo;
% interior = CT_seg_filtered & ~endo & ~epi;

%% Show segmented endo/epicardium

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(endo, 'Parent', vwr, 'Colormap', [0,0,0.75])
volshow(epi, 'Parent', vwr, 'AlphaMap', linspace(0, 0.1, 256))     

%% Distance transform

endo_dist_map = bwdist(endo);
endo_dist_map_mm = endo_dist_map * PixelDims(1); % convert pixels -> mm
% endo_dist_map_mm(~CT_seg_filtered) = -1000;

%% Show distance map

vwr = viewer3d('BackgroundColor', 'w', 'GradientColor', 'w');
volshow(endo_dist_map_mm, 'Colormap', parula, 'DataLimits', [0,2], ...
    'AlphaData', CT_seg_filtered, 'Parent', vwr);

