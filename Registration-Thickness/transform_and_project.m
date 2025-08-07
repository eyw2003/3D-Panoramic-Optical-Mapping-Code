function fixedVolumeProj = transform_and_project(movingVolume, fixedVolume, trans, varargin)
%% validate ordered inputs
narginchk(3, inf);
assert(isnumeric(movingVolume), 'Expected moving volume to be numeric.');
assert(islogical(fixedVolume), 'Expected fixed volume to be logical (boolean).');
assert(isa(trans, 'affinetform3d'), 'Expected transformation to be an affine transformation.');

%% parse key-value inputs

p = inputParser();
addParameter(p, 'MovingDataLimits', [min(movingVolume(:)), max(movingVolume(:))], @(l) length(l) == 2 || l(2) > l(1));
addParameter(p, 'MissingValue', 0, @isscalar);
addParameter(p, 'DistanceThreshold', 10,  @isscalar);
addParameter(p, 'Neighbors', 10, @(k) isscalar(k) && isnumeric(k));

parse(p, varargin{:});

movingDataLimits = p.Results.MovingDataLimits;
missingVal = p.Results.MissingValue;
distanceThreshold = p.Results.DistanceThreshold;
neighbors = p.Results.Neighbors;

%% obtain nonzero/valid voxel coordinates for both volumes

fixedInds = find(fixedVolume);
[fy, fx, fz] = ind2sub(size(fixedVolume), fixedInds);
fixedPoints = [fx, fy, fz];

movingInds = find(movingVolume >= movingDataLimits(1) & movingVolume <= movingDataLimits(2));
movingVals = movingVolume(movingInds);
[my, mx, mz] = ind2sub(size(movingVolume), movingInds);
movingPoints = [mx, my, mz];

%% transform valid moving volume voxel coordinates

transformedPoints = trans.transformPointsForward(movingPoints); % tform moving points to fixed space

%%

% find nearest transformed point for each fixed point
[nearestInds, dists] = knnsearch(transformedPoints, fixedPoints, 'K', neighbors);
nearestVals = movingVals(nearestInds);

nearestVals(dists > distanceThreshold) = nan;
nearestVals = mean(nearestVals, 2, 'omitnan');

nearestVals(isnan(nearestVals)) = missingVal;

%%

fixedVolumeProj = -1000 * ones(size(fixedVolume));
fixedVolumeProj(fixedInds) = nearestVals;

end