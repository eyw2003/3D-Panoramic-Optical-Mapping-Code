function outstats = regionprops3BoundingBox(Map)
%REGIONPROPS3 Measure properties of 3-D volumetric image regions.
%   STATS = REGIONPROPS3(BW,PROPERTIES) measures a set of properties for
%   each connected component (object) in the 3-D volumetric binary image
%   BW. The output STATS is a MATLAB table with height (number of rows)
%   equal to the number of objects in BW, CC.NumObjects, or max(L(:)). The
%   variables of the table denote different properties for each region, as
%   specified by PROPERTIES. See help for 'table' in MATLAB for additional
%   methods for the table.
%
%   STATS = REGIONPROPS3(CC,PROPERTIES) measures a set of properties for
%   each connected component (object) in CC, which is a structure returned
%   by BWCONNCOMP. CC must be the connectivity of a 3-D volumetric image i.e.
%   CC.ImageSize must be a 1x3 vector.
%
%   STATS = REGIONPROPS3(L,PROPERTIES) measures a set of properties for each
%   labeled region in the 3-D label matrix L. Positive integer elements of L
%   correspond to different regions. For example, the set of elements of L
%   equal to 1 corresponds to region 1; the set of elements of L equal to 2
%   corresponds to region 2; and so on.
%
%   STATS = REGIONPROPS3(...,V,PROPERTIES) measures a set of properties for
%   each labeled region in the 3-D volumetric grayscale image V. The first
%   input to REGIONPROPS3 (BW, CC, or L) identifies the regions in V.  The
%   sizes must match: SIZE(V) must equal SIZE(BW), CC.ImageSize, or
%   SIZE(L).
%
%   PROPERTIES can be a comma-separated list of strings or character
%   vectors, a cell array containing strings or character vectors,
%   "all", or "basic". The set of valid measurement strings or character
%   vectors includes:
%
%   Shape Measurements
%
%     "Volume"              "PrincipalAxisLength"  "Orientation"               
%     "BoundingBox"         "Extent"               "SurfaceArea"          
%     "Centroid"            "EquivDiameter"        "VoxelIdxList" 
%     "ConvexVolume"        "VoxelList"            "ConvexHull"   
%     "Solidity"            "ConvexImage"          "Image"  
%     "SubarrayIdx"         "EigenVectors"         "EigenValues"
%
%   Voxel Value Measurements (requires 3-D volumetric grayscale image as the second input)
%
%     "MaxIntensity"
%     "MeanIntensity"
%     "MinIntensity"
%     "VoxelValues"
%     "WeightedCentroid"
%
%   Property strings or character vectors are case insensitive and can be
%   abbreviated.
%
%   If PROPERTIES is set to "all", REGIONPROPS3 returns all of the Shape
%   measurements. If called with a 3-D volumetric grayscale image,
%   REGIONPROPS3 also returns Voxel value measurements. If PROPERTIES is
%   not specified or if it is set to "basic", these measurements are
%   computed: "Volume", "Centroid", and "BoundingBox".
%
%   Note that negative-valued voxels are treated as background
%   and voxels that are not integer-valued are rounded down.
%
%   Example 1
%   ---------
%   % Estimate the centers and radii of objects in a 3-D volumetric image
%
%         % Create a binary image with two spheres
%         [x, y, z] = meshgrid(1:50, 1:50, 1:50);
%         bw1 = sqrt((x-10).^2 + (y-15).^2 + (z-35).^2) < 5;
%         bw2 = sqrt((x-20).^2 + (y-30).^2 + (z-15).^2) < 10;
%         bw = bw1 | bw2;
%         s = regionprops3(bw, "Centroid", ...
%                            "PrincipalAxisLength");
%
%         % Get centers and radii of the two spheres
%         centers = s.Centroid;
%         diameters = mean(s.PrincipalAxisLength,2);
%         radii = diameters/2;
%
%
%   Class Support
%   -------------
%   If the first input is BW, BW must be a 3-D logical array. If the first
%   input is CC, CC must be a structure returned by BWCONNCOMP. If the
%   first input is L, L must be real, nonsparse, numeric array containing 3
%   dimensions.
%
%   See also BWCONNCOMP, BWLABELN, ISMEMBER, REGIONPROPS.

%   Copyright 2017 The MathWorks, Inc.

narginchk(1, inf);

if islogical(Map) || isstruct(Map)
    %REGIONPROPS3(BW,...) or REGIONPROPS3(CC,...)
    
    L = [];
    
    if islogical(Map)
        %REGIONPROPS3(BW,...)
        if ndims(Map) > 3
            error(message('images:regionprops3:invalidSizeBW'));
        end
        CC = bwconncomp(Map);
    else
        %REGIONPROPS3(CC,...)
        CC = Map;
        checkCC(CC);
        if numel(CC.ImageSize) > 3
            error(message('images:regionprops3:invalidSizeCC'));
        end
    end
    
    imageSize = CC.ImageSize;
    numObjs = CC.NumObjects;   
    
else
    %REGIONPROPS3(L,...)
    
    CC = [];
    
    L = Map;
    supportedTypes = {'uint8','uint16','uint32','int8','int16','int32','single','double'};
    supportedAttributes = {'3d','real','nonsparse','finite'};
    validateattributes(L, supportedTypes, supportedAttributes, ...
        mfilename, 'L', 1);
    imageSize = size(L);
    
    if isempty(L)
        numObjs = 0;
    else
        numObjs = max( 0, floor(double(max(L(:)))) );
    end
end

[V,requestedStats,officialStats] = parseInputs(imageSize,Map);
requestedStats{1} = 'BoundingBox';            
[stats, statsAlreadyComputed] = initializeStatsTable(...
    numObjs, requestedStats, officialStats);

% Compute VoxelIdxList
[stats, statsAlreadyComputed] = ...
    computeVoxelIdxList(L, CC, numObjs, stats, statsAlreadyComputed);

[stats, statsAlreadyComputed] = ...
                computeBoundingBox(imageSize,stats,statsAlreadyComputed);

% Create the output table.
outstats = createOutputTable(requestedStats, stats);

%% computeVoxelIdxList
function [stats, statsAlreadyComputed] = ...
    computeVoxelIdxList(L,CC,numObjs,stats,statsAlreadyComputed)
%   A P-by-1 matrix, where P is the number of voxels belonging to
%   the region.  Each element contains the linear index of the
%   corresponding voxel.

statsAlreadyComputed.VoxelIdxList = 1;

if numObjs ~= 0
    if ~isempty(CC)
        idxList = CC.PixelIdxList;
    else
        idxList = label2idxmex(L, double(numObjs));
    end
    stats.VoxelIdxList = idxList';
end


%% computeBoundingBox
function [stats, statsAlreadyComputed] = ...
    computeBoundingBox(imageSize,stats,statsAlreadyComputed)
%   Note: The output format is [minC minR minP width height depth] and
%   minC, minR, minP end in .5, where minC, minR and minP are the minimum
%   column, minimum row and minimum plane values respectively

if ~statsAlreadyComputed.BoundingBox
    statsAlreadyComputed.BoundingBox = 1;
    
    [stats, statsAlreadyComputed] = ...
        computeVoxelList(imageSize,stats,statsAlreadyComputed);
  
    for k = 1:height(stats)
        list = stats.VoxelList{k};
        if (isempty(list))
            stats.BoundingBox{k} = [0.5*ones(1,3) zeros(1,3)];
        else
            minCorner = min(list,[],1) - 0.5;
            maxCorner = max(list,[],1) + 0.5;
            stats.BoundingBox{k} = [minCorner (maxCorner - minCorner)];
        end
    end
end

%% computeVoxelList
function [stats, statsAlreadyComputed] = ...
    computeVoxelList(imageSize,stats,statsAlreadyComputed)
%   A P-by-3 matrix, where P is the number of voxels belonging to
%   the region.  Each row contains the row, column and plane
%   coordinates of a voxel.

if ~statsAlreadyComputed.VoxelList
    statsAlreadyComputed.VoxelList = 1;
    
    ndimsL = 3;
    % Convert the linear indices to subscripts and store
    % the results in the voxel list.  Reverse the order of the first
    % two subscripts to form x-y order.
    In = cell(1,ndimsL);
    for k = 1:height(stats)
        if ~isempty(stats.VoxelIdxList{k})
            [In{:}] = ind2sub(imageSize, stats.VoxelIdxList{k});
            stats.VoxelList{k} = [In{:}];
            stats.VoxelList{k} = stats.VoxelList{k}(:,[2 1 3]);
        else
            stats.VoxelList{k} = zeros(0,ndimsL);
        end
    end
end


function [V, reqStats, officialStats] = parseInputs(sizeImage, varargin)

shapeStats = {
    'Volume'
    'Centroid'
    'BoundingBox'
    'SubarrayIdx'
    'Image'
    'EquivDiameter'
    'Extent'
    'VoxelIdxList'
    'VoxelList'
    'PrincipalAxisLength'
    'Orientation'
    'EigenVectors'
    'EigenValues'
    'ConvexHull'
    'ConvexImage'
    'ConvexVolume'
    'Solidity'
    'SurfaceArea'};

voxelValueStats = {
    'VoxelValues'
    'WeightedCentroid'
    'MeanIntensity'
    'MinIntensity'
    'MaxIntensity'};

basicStats = {
    'Volume'
    'Centroid'
    'BoundingBox'};

V = [];
officialStats = shapeStats;

numOrigInputArgs = numel(varargin);

if numOrigInputArgs == 1
    %REGIONPROPS3(BW) or REGIONPROPS3(CC) or REGIONPROPS3(L)
    
    reqStats = basicStats;
    return;
    
elseif isnumeric(varargin{2}) || islogical(varargin{2})
    %REGIONPROPS3(...,V) or REGIONPROPS3(...,V,PROPERTIES)
    
    V = varargin{2};
    validateattributes(V, {'numeric','logical'},{}, mfilename, 'V', 2);
    
    iptassert(isequal(sizeImage,size(V)), ...
        'images:regionprops3:sizeMismatch')
    
    officialStats = [shapeStats;voxelValueStats];
    if numOrigInputArgs == 2
        %REGIONPROPS3(BW) or REGIONPROPS3(CC,V) or REGIONPROPS3(L,V)
        reqStats = basicStats;
        return;
    else
        %REGIONPROPS3(BW,V,PROPERTIES) of REGIONPROPS3(CC,V,PROPERTIES) or
        %REGIONPROPS3(L,V,PROPERTIES)
        startIdxForProp = 3;
        reqStats = getPropsFromInput(startIdxForProp, ...
            officialStats, voxelValueStats, basicStats, varargin{:});
    end
    
else
    %REGIONPROPS3(BW,PROPERTIES) or REGIONPROPS3(CC,PROPERTIES) or
    %REGIONPROPS3(L,PROPERTIES)
    startIdxForProp = 2;
    reqStats = getPropsFromInput(startIdxForProp, ...
        officialStats, voxelValueStats, basicStats, varargin{:});
end

function [reqStats,officialStats] = getPropsFromInput(startIdx, ...
    officialStats, voxelValueStats, basicStats, varargin)

if iscell(varargin{startIdx})
    %REGIONPROPS3(...,PROPERTIES)
    propList = varargin{startIdx};
elseif strcmpi(varargin{startIdx}, 'all')
    %REGIONPROPS3(...,'all')
    reqStats = officialStats;
    return;
elseif strcmpi(varargin{startIdx}, 'basic')
    %REGIONPROPS3(...,'basic')
    reqStats = basicStats;
    return;
else
    %REGIONPROPS3(...,PROP1,PROP2,..)
    propList = varargin(startIdx:end);
end

numProps = length(propList);
reqStats = cell(1, numProps);
for k = 1 : numProps
    if ischar(propList{k})
        noGrayscaleImageAsInput = startIdx == 2;
        if noGrayscaleImageAsInput
            % This code block exists so that regionprops3 can throw a more
            % meaningful error message if the user want a voxel value based
            % measurement but only specifies a label matrix as an input.
            tempStats = [officialStats; voxelValueStats];
            prop = validatestring(propList{k}, tempStats, mfilename, ...
                'PROPERTIES', k+1);
            if any(strcmp(prop,voxelValueStats))
                error(message('images:regionprops3:needsGrayscaleImage', prop));
            end
        else
            prop = validatestring(propList{k}, officialStats, mfilename, ...
                'PROPERTIES', k+2);
        end
        reqStats{k} = prop;
    else
        error(message('images:regionprops3:invalidType'));
    end
end

function [stats, statsAlreadyComputed] = initializeStatsTable(...
    numObjs, requestedStats, officialStats)

if isempty(requestedStats)
    error(message('images:regionprops3:noPropertiesWereSelected'));
end

% Initialize the stats table.
tempStats = {'SurfaceVoxelList';'DelaunayTriangulation'};
allStats = [officialStats; tempStats];
numStats = length(allStats);
empties = cell(numObjs, numStats);
stats = cell2table(empties,'VariableNames',allStats);
% Initialize the statsAlreadyComputed structure array. Need to avoid
% multiple calculatations of the same property for performance reasons.
zz = cell(numStats, 1);
for k = 1:numStats
    zz{k} = 0;
end
statsAlreadyComputed = cell2struct(zz, allStats, 1);

function outstats = createOutputTable(requestedStats, stats)

% Figure out what fields to keep and what fields to remove.
fnames = stats.Properties.VariableNames;
idxRemove = ~ismember(fnames, requestedStats);
idxKeep = ~idxRemove;

% Convert to cell array
c = table2cell(stats);
sizeOfc = size(c);

% Determine size of new cell array that will contain only the requested
% fields.

newSizeOfc = sizeOfc;
newSizeOfc(2) = sizeOfc(2) - numel(find(idxRemove));
newFnames = fnames(idxKeep);

% Create the output structure.
outstats = cell2table(reshape(c(:,idxKeep), newSizeOfc), 'VariableNames',newFnames);
