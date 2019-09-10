function medianParams = medianWindow(inputParams)

% Take a matrix of values and return the median of each column
% 
% function medianParams = medianWindow(inputParams)
%
% medianParams  - The median of each input column
%
% inputParams   - The values for which medians are required

% Version    Author       Date      Affiliation
% 1.00       J K Summers  23/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

medianParams = zeros(1, size(inputParams, 2));

for i = 1:size(inputParams, 2)
    medianParams(i) = mean(inputParams(:, i));
end

end