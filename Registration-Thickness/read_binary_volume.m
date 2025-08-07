function data = read_binary_volume(filename, dims)

fid = fopen(filename, 'rb');
assert(fid > 0, 'Could not open file.');
data = fread(fid, prod(dims), 'double');
data = reshape(data, dims);
fclose(fid);

end