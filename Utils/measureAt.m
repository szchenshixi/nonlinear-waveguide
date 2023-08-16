% This function does interpolation first and pick the data value at a point
% that is cloest to the requested point. Take care of the interpolation
% granularity when used in specific scenarios.
function data_o = measureAt(data_i, index, requestAt)
interpolation_granularity = 1e-4; % Meaning generates (1e4 + 1) data points for a plot
index_interp = index(1) : index(end)*interpolation_granularity : index(end);
data_interp = interp1(index, data_i, index_interp, 'spline');
[~, i] = min(abs(index_interp - requestAt));  % ~ means dummy variable
% Save the interpolated data to .mat file
% save(data_i(1)+"mW",'data_interp','index_interp')
data_o = data_interp(i);
end