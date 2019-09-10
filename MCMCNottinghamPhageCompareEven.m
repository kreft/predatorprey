function [abcValuesSing, abcValuesBoth] = ...
    MCMCNottinghamPhageCompareEven(protocolFile, dataFile, sucesses, ...
    reportWindow, acceptError1, acceptError2, compMode, savePlot)

% Run the MCMC progress to attempt to fit paramters for observed data.
% For single predator only and dual predation & compare them
% 
% Data and information on priors are read in from the data and protocol 
% files
%
% function [abcValuesSing, abcValuesBoth] = ...
%    MCMCNottinghamPhageCompareEven(protocolFile, dataFile, sucesses, ...
%    reportWindow, acceptError1, acceptError2, compMode, savePlot)
%
% abcValuesSing - The different parameter settings tried that passed the
% threshold for acceptance match to single predator data only
% abcValuesBoth - The different parameter settings tried that passed the
% threshold for acceptance match to all data
%
% protocolFile  - The parameters for the fitting process
% dataFile      - Data to fit to
% success       - The number of sucesses needed
% reportWindow  - Show acceptance percentage over the last this many tries
% acceptError1  - Factor by which to adjust parameter acceptance threshold
%				  for single predator only data
% acceptError2	- Factor by which to adjust parameter acceptance threshold
%				  for all data
% compMode      - How should simulated and observed data be compared?
% savePlot      - Should the plots be saved

% Version    Author       Date      Affiliation
% 1.00       J K Summers  10/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

tic
params = readtable(protocolFile);

numParams = params.numParams(1);
paramNames = params.paramNames(1: numParams);
plotTitle = ['Even ' char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' AR1' num2str(acceptError1) ' AR2' num2str(acceptError2) ...
     ' I' num2str(sucesses) ' '];

[abcValuesSing, ~] = MCMCNottinghamPhageNoLEven(protocolFile, ...
    dataFile, sucesses, reportWindow, acceptError1, compMode, false, ...
    savePlot);
[abcValuesBoth, ~] = MCMCNottinghamPhageNoLEven(protocolFile, ...
    dataFile, sucesses, reportWindow, acceptError2, compMode, true, ...
    savePlot);

plotDoubleHistograms(log10(abcValuesSing), log10(abcValuesBoth), ...
    paramNames, true, savePlot, plotTitle);

toc
end