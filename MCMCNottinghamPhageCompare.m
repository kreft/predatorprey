function [abcValuesSing, abcValuesBoth, dataGapsS, dataGapsS2, ...
    dataGapsD, dataGapsD2] = MCMCNottinghamPhageCompare(protocolFile, ...
    dataFile, tries, starts, reportWindow, acceptError1, acceptError2, ...
    compMode, savePlot)

% Run the MCMC progress to attempt to fit paramters for observed data.
% 
% Data and information on priors are read in from the data and protocol 
% files. Matching is done for single predators only and full matching
%
% function [abcValuesSing, abcValuesBoth, dataGapsS, dataGapsS2, ...
%     dataGapsD, dataGapsD2] = MCMCNottinghamPhageCompare(protocolFile, ...
%     dataFile, tries, reportWindow, acceptError1, acceptError2, ...
%     compMode, savePlot)
%
% abcValuesSing - The different parameter settings tried that passed the
% threshold for acceptance on single predator data only
% abcValuesBoth - The different parameter settings tried that passed the
% threshold for acceptance on all data
% dataGapsS     - Gaps between single predator simulated and observed data
% for accepted single match parameters
% dataGapsS2    - Gaps between all simulated and observed data for 
% accepted single match parameters
% dataGapsD     - Gaps between single predator simulated and observed data
% for accepted all match parameters
% dataGapsD2    - Gaps between all simulated and observed data for 
% accepted all match parameters
%
% protocolFile  - The parameters for the fitting process
% dataFile      - Data to fit to
% tries         - The number of parameter settings to try
% reportWindow  - Show acceptance percentage over the last this many tries
% acceptError1  - Distance allowed between single predator simulated and
% observed data
% acceptError2  - Distance allowed between all simulated and observed data
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
plotTitle = [char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' Dual gaps AR1' num2str(acceptError1) ...
     ' AR2' num2str(acceptError2) ' I' num2str(tries) ' '];
 
[abcValuesSing, ~, dataGapsS, dataGapsS2] = ...
    MCMCNottinghamPhageNoLRnd(protocolFile, dataFile, tries, starts, ...
    reportWindow, acceptError1, compMode, false, savePlot);
[abcValuesBoth, ~, dataGapsD, dataGapsD2] = ...
    MCMCNottinghamPhageNoL(protocolFile, dataFile, tries, ...
    reportWindow, acceptError2, compMode, true, savePlot);
 
plotDoubleHistograms(log10(abcValuesSing), log10(abcValuesBoth), ...
    paramNames, false, savePlot, plotTitle);
 
toc
end

