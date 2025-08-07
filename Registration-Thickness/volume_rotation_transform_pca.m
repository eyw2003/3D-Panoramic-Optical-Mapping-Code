function [Tfull] = volume_rotation_transform_pca(V, flip_z, adjust, pca_samples)
narginchk(1,4);

if nargin < 4 || isempty(pca_samples)
    pca_samples = 100000; % Default
end

if nargin < 3 || isempty(pca_samples)
    adjust = false;
end

if nargin < 2 || isempty(flip_z)
    flip_z = false;
end

R = rotmat_from_pcs(V, flip_z, pca_samples);
% R = eye(3);

if adjust
    R = adjust_rotmat(V, R);
end

Tfull = decentered_rotation_transform(V, R);

end