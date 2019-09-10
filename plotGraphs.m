function plotGraphs(paramVals, simMode, fixedVals, dataVals, simTimes, ...
    savePlot, fileBase)

% Create a series of log plots of simulation results for the parameters.
% 
% The y-axis should be a log scale. There will be four graphs
% 1. E. coli only
% 2. E. coli & Bdellovibrio
% 3. E. coli & halophage
% 4. E. coli, Bdellovibrio & halophage
%
% E. coli values are in blue, Bdellovibrio - red, halophage - yellow
%
% function plotGraphs(paramVals, simMode, fixedVals, dataVals, simTimes, ...
%     savePlot, fileBase)
%
% paramVals     - The parameters for the simulation
% simMode       - Which ODE equations should be used
% fixedVals     - Some values which are not changed
% dataVals		- Initial species numbers
% simTimes      - Time points for which data should be plotted.
% savePlot      - Should plots be saved?
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  09/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.01		 J K Summers  05/10/18	Pass in initial species numbers  
%									seperately from fixedVals

plotVals = getSpecies(paramVals, fixedVals, dataVals, simTimes, ...
    simMode, false);

fileName = [fileBase ' E coli only species values'];
plotSpecies(simTimes, plotVals(:, 1, 1:2), 'mb', ...
    {'Species enumerations', 'for E. coli only', ''}, savePlot, fileName);

fileName = [fileBase ' E coli and Bdellovibrio species values'];
plotSpecies(simTimes, plotVals(:, 2, 1:3), 'mbr', ...
    {'Species enumerations', 'for E. coli and Bdellovibrio', ''}, ...
    savePlot, fileName);

fileName = [fileBase ' E coli and Halophage species values'];
plotSpecies(simTimes, plotVals(:, 3, [1 2 4]), 'mbg', ...
    {'Species enumerations', 'for E. coli and Halophage', ''}, ...
    savePlot, fileName);

fileName = ...
    [fileBase ' E coli, Bdellovibrio and Halophage species values'];
plotSpecies(simTimes, plotVals(:, 4, 1:4), 'mbrg', ...
    {'Species enumerations', ...
    'for E. coli, Bdellovibrio and Halophage', ''}, savePlot, fileName);

end