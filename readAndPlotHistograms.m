function readAndPlotHistograms(targetDir, savePlot)
 
% Plot all histograms for all parameter data in the files
% 
% Reads in all the parameter files in the target directory. For each
% parameter plots on the same graph histograms for all values of that
% parameter in each parameter file.
%
% function readAndPlotHistograms(targetDir, savePlot)
%
% targetDir     - The directory to read files from
% savePlot      - Should the plots be saved
 
% Version    Author       Date      Affiliation
% 1.00       J K Summers  01/11/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
 
tic
cd(targetDir);
dataFiles = dir(fullfile(pwd, '*.xlsx'));

for i = 1:size(dataFiles)
    params = readtable(dataFiles(i).name);
    paramsA = table2array(params);
 
%     numParams = size(paramsA, 2);
   
    paramNames = params.Properties.VariableNames;
    histData(i).paramData = paramsA;
end

fileBase = [targetDir ' Histograms '];

try
	plotConvergeHistograms(histData, paramNames, true, savePlot, fileBase)
catch
end

toc
end

