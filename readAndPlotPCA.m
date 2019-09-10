function readAndPlotPCA(dataFile, showDist, savePlot, fileBase)
 
% Read in parameters, perform PCA and plot the results
% 
% function readAndPlotPCA(dataFile, savePlot, fileBase)
%
% dataFile      - The file containing the parameter data
% savePlot      - Should the plots be saved
% fileBase      - Name to store plots as
 
% Version    Author       Date      Affiliation
% 1.00       J K Summers  07/11/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
 
tic

params = readtable(dataFile);
paramsA = table2array(params);
 
% numParams = size(paramsA, 2);
   
paramNames = params.Properties.VariableNames;
[paramCoeffs, scores] = pca(paramsA);

plotPCA(paramCoeffs, scores, paramNames, showDist, '', 0, savePlot, fileBase)

toc
end
