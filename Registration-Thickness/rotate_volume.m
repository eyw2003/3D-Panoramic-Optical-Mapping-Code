function [V_new] = rotate_volume(V, tform, interp)
% ROTATE_VOLUME Rotates and centers a binary 3D volume
narginchk(2,3)
if nargin < 3
    interp = 'linear';
end

% Create a grid for the new volume
[XG, YG, ZG] = ndgrid(1:size(V,1), 1:size(V,2), 1:size(V,3));
coords = [XG(:) YG(:) ZG(:), ones(numel(XG),1)];
clear XG YG ZG % free up memory

Ainv = inv(tform.A);
F = griddedInterpolant(double(V), interp);

n_coords = height(coords);
target_chunk_size = 5e6;
n_chunks = round(n_coords / target_chunk_size);

chunk_starts = round(linspace(1,n_coords+1,n_chunks+1));
V_new = zeros(numel(V), 1);

n_blocks = 30;
disp('Rotating and interpolating volume points.')

for i = 1:n_chunks
    start_ind = chunk_starts(i);
    end_ind = chunk_starts(i+1)-1;
    chunk = coords(start_ind:end_ind,:);
    new_chunk = chunk * Ainv';
    % new_coords(start_ind:end_ind,:) = new_chunk;
    V_new(start_ind:end_ind) = F(new_chunk(:,1:3));
    %fprintf('Done chunk %d of %d\n', i, n_chunks);
    frac_done = i/n_chunks;
    blocks = round(frac_done / (1/n_blocks));
    if i > 1
        fprintf(repmat('\b', 1, numel(print_str)));
    end
    print_str = sprintf('|%s%s| %5.1f', repmat(char(9608), 1, blocks), ...
        repmat(' ', 1, n_blocks - blocks), frac_done*100);
    fprintf(print_str);
    pause(0);
end
fprintf('\nDone.\n')

V_new = reshape(V_new, size(V));

if islogical(V)
    V_new = V_new > 0.5; % reshape back into volume
end

end

