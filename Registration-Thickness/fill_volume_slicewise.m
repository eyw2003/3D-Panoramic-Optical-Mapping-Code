function filled_vol = fill_volume_slicewise(vol, slice_dims)
narginchk(1,2);
if nargin < 2
    slice_dims = 1:ndims(vol);
end

maxiters = 10;

filled_vol = vol;
for k = 1:maxiters
    tic
    any_different = false;
    for d = slice_dims
        inds = repmat({':'}, 1, ndims(filled_vol));
        for i = 1:size(filled_vol, d)
            inds{d} = i;
            slice = squeeze(filled_vol(inds{:}));
            new_slice = imfill(slice, 'holes');
            any_different = any_different || ~all(slice == new_slice, 'all');
            filled_vol(inds{:}) = new_slice;
        end
    end
    fprintf('Iteration %d (%.1f s): changes? %d\n', k, toc, any_different)
    if ~any_different
        break
    end
end

end