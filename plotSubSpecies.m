function plotSubSpecies(paramVals, simMode, fixedVals, ...
    dataVals, savePlot, fileBase)

% Plot simulated sub species data in one plot
% 
% The y-axis should be a log scale. There will be four graphs
% 1. E. coli only
% 2. E. coli & Bdellovibrio
% 3. E. coli & halophage
% 4. E. coli, Bdellovibrio & halophage
%
% E. coli values are in blue
%   Sensitive 'o'
%   Bdellovibrio persistent '+'
%   Phage resistant 'x'
%   Bdellovibrio - red square
%   Bdelloplast - red pentagon
%   Halophage - green diamond
%   Infected cell - green hexagon
%
% function plotSubSpecies(paramVals, simMode, fixedVals, ...
%    dataVals, savePlot, fileBase)
%
% paramVals     - The parameters for the simulation
% simMode       - Which ODE equations should be used
% fixedVals     - Some values which are not changed
% dataVals		- Initial species values
% savePlot      - Should plots be saved?
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  01/12/18  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

dataFile= 'Nottingham Phage Data.xlsx';
data = readtable(dataFile);
simTimes = data.times;

plotVals = getSpecies(paramVals, fixedVals, dataVals, simTimes, ...
    simMode, true);

fileName = [fileBase ' E coli only sub species'];
plotGraphSubSpecies(simTimes, plotVals(:, 1, 1:4), 'mbbb', ...
    'o+x', {'Sub species enumerations', 'for E. coli only', ''}, ...
    false, fileName);

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 8.3 8.3];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

fileName = [fileBase ' E coli and Bdellovibrio sub species'];
plotGraphSubSpecies(simTimes, plotVals(:, 2, 1:6), 'mbbbrr', 'o+xsp', ...
    {'Sub species enumerations', 'for E. coli and Bdellovibrio', ''}, ...
    savePlot, fileName);

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 8.3 8.3];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

fileName = [fileBase ' E coli and Halophage sub species'];
plotGraphSubSpecies(simTimes, plotVals(:, 3, [1 2 3 4 7 8]), 'mbbbgg', ...
    'o+xdh', ...
    {'Sub species enumerations', 'for E. coli and Halophage', ''}, ...
    savePlot, fileName);

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 8.3 8.3];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

fileName = ...
    [fileBase ' E coli, Bdellovibrio and Halophage sub species'];
plotGraphSubSpecies(simTimes, plotVals(:, 4, 1:8), 'mbbbrrgg', ...
    'o+xspdh', {'Sub species enumerations', ...
    'for E. coli, Bdellovibrio and Halophage', ''}, savePlot, fileName);

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 8.3 8.3];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end