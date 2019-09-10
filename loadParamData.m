function paramData = loadParamData(dataPath)

% Load parameter data for all excel files in the directory passed in
% 
% function paramData = loadParamData(dataPath)
%
% paramData     - The data loaded
% 
% dataPath      - The directory to load files from

% Version    Author       Date      Affiliation
% 1.00       J K Summers  30/10/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

dataFiles = dir(fullfile(dataPath, '*.xlsx'));

numFiles = length(dataFiles);

for i = 1 : numFiles
    params = readtable(dataFiles(i).name);
    paramData(i, :, :) = params;
end

end