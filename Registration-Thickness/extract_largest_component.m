function largest_volume = extract_largest_component(bw, varargin)
% EXTRACT_LARGEST_COMPONENT Extract the largest connected component in a 3D volume
%
%   largest_volume = extract_largest_component(volume, 'MinSizeRatio', 10, 'Connectivity', 6)
%
% Inputs:
%   volume          - 3D logical array (input binary volume)
%
% Optional Name-Value Pairs:
%   'MinSizeRatio'  - (default 10) Scalar, largest must be N times bigger than second largest
%   'Connectivity'  - (default 6) Connectivity for bwconncomp: 6, 18, or 26
%   'Verbose'       - (default false) verbosity
%
% Output:
%   largest_volume  - 3D logical array, only the largest component kept

if ndims(bw) == 3
    conns = [6, 18, 26];
    default_conn = 18;
else
    conns = [4, 8];
    default_conn = 4;
end

if ndims(squeeze(bw)) == 3
    default_min_size_ratio = 50;
else
    default_min_size_ratio = 10;
end


% Input parsing
p = inputParser();
p.addParameter('MinSizeRatio', default_min_size_ratio, ...
    @(x) isnumeric(x) && isscalar(x) && (x > 0));
p.addParameter('Connectivity', default_conn, @(x) ismember(x, conns));
p.addParameter('Verbose', false, @(x) isscalar(x) && islogical(x));

parse(p, varargin{:});

min_size_ratio = p.Results.MinSizeRatio;
connectivity = p.Results.Connectivity;
verbose = p.Results.Verbose;

% Connected component analysis
cc = bwconncomp(bw, connectivity);
num_components = cc.NumObjects;

if num_components == 0
    error('No connected components found in volume.');
else
    if verbose
        fprintf('%d distinct components found (%d connectivity)\n', ...
            num_components, connectivity);
    end
end

% Find size of each component
component_sizes = cellfun(@numel, cc.PixelIdxList);

% Sort by size
[sorted_sizes, sort_idx] = sort(component_sizes, 'descend');

% Check size ratio between largest and second-largest
if num_components > 1
    size_ratio = sorted_sizes(1) / sorted_sizes(2);
    if size_ratio < min_size_ratio
        warning(['Largest component is only %.2fx bigger than second largest. ', ...
            'Consider checking segmentation quality.'], size_ratio);
    end
    if verbose
        figure;
        bar(sorted_sizes);
        ax = gca;
        ax.YAxis.Scale = 'log';
        ax.YLabel.String = 'Pixels';
        ax.XLabel.String = 'Component #';
        ax.FontSize = 14;
        ax.XLim = [0, min(num_components, 10)] + 0.5;
    end
end

% Create output volume
largest_volume = false(size(bw));
largest_volume(cc.PixelIdxList{sort_idx(1)}) = true;
end
