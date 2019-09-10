function MCMCNottinghamPhageSetTol(protocolFile, dataFile, tries, ...
    tolerances, reportWindow, compMode, fitAll, savePlot)
 
% Run the MCMC progress for a range of tolerances.
% 
% Data and information on priors are read in from the data and protocol 
% files. Matching is done for single predators only or full matching
%
% function MCMCNottinghamPhageSetTol(protocolFile, dataFile, tries, ...
%     tolerances, reportWindow, compMode, fitAll, savePlot)
%
% protocolFile  - The parameters for the fitting process
% dataFile      - Data to fit to
% tries         - The number of parameter settings to try
% tolerances    - The various tolerances to try
% reportWindow  - Show acceptance percentage over the last this many tries
% compMode      - How should simulated and observed data be compared?
% fitAll        - Should fit be to all data, or only single predator data?
% savePlot      - Should the plots be saved
 
% Version    Author       Date      Affiliation
% 1.00       J K Summers  25/10/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%
 
tic
tolNums = size(tolerances, 2);
 
for i = 1:tolNums
    tol = tolerances(i);
    [abcParams(i).paramData, paramWidths(i, :), SDParams(i, :), paramNames] = ...
        MCMCNottinghamPhageNoL(protocolFile, dataFile, tries, ...
        reportWindow, tol, compMode, fitAll, savePlot); 
end

% plotHistShapes(paramWidths, 'Widths', protocolFile, savePlot);
% plotHistShapes(SDParams, 'SDs', protocolFile, savePlot);

for i = 1:tolNums
    plotConvergeHistograms(abcParams(i), protocolFile, true, savePlot)
end

% NottinghamPlotSeries(abcParams(tolNums), 0:2:48, ...
%     false, tolerances(tolNums), '', false)

toc
end

