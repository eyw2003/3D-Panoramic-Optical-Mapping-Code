function [varargout] = crop_volume(V,padding)
% CROP_EMPTY: remove area outside bounding box
narginchk(1,2);
nargoutchk(0,2);
assert(islogical(V), 'Expected volume to be logical (boolean).');

if nargin < 2
    padding = 1;
end

bbox = cell(1, ndims(V));
all_dims = 1:ndims(V);
for i = all_dims
    tf = any(V, all_dims(all_dims ~= i));
    start_ind = find(tf, 1, 'first');
    padded_start_ind = max(start_ind - padding, 1);
    actual_start_padding = start_ind - padded_start_ind;
    if actual_start_padding ~= padding
        fprintf('Insufficient space to pad by %d along beginning of dim %d, padded by %d.\n', ...
            padding, i, actual_start_padding);
    end
    end_ind = find(tf, 1, 'last');
    padded_end_ind = min(end_ind + padding, size(V, i));
    actual_end_padding = padded_end_ind - end_ind;
    if actual_end_padding ~= padding
        fprintf('Insufficient space to pad by %d along end of dim %d, padded by %d.\n', ...
            padding, i, actual_end_padding);
    end
    bbox{i} = padded_start_ind:padded_end_ind;
end

cropped = V(bbox{:});

varargout = {cropped};
if nargout > 1
    varargout = [varargout, {bbox}];
end

end