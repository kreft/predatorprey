function plotGraphsVsData(paramVals, simMode, fixedVals, ...
    dataVals, savePlot, fileBase)

% Plot simulated and observed data in one plot
% 
% The y-axis should be a log scale. There will be four graphs
% 1. E. coli only
% 2. E. coli & Bdellovibrio
% 3. E. coli & halophage
% 4. E. coli, Bdellovibrio & halophage
%
% E. coli values are in blue, Bdellovibrio - red, halophage - yellow
%
% function plotGraphsVsData(paramVals, simMode, fixedVals, ...
%    dataVals, savePlot, fileBase)
%
% paramVals     - The parameters for the simulation
% simMode       - Which ODE equations should be used
% fixedVals     - Some values which are not changed
% dataVals		- Initial species values
% savePlot      - Should plots be saved?
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  05/01/18  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

dataFile= 'Nottingham Phage Data.xlsx';
data = readtable(dataFile);
simTimes = data.times;

obsData(:, 1) = data.EColiOnly;
obsData(:, 2) = data.EColiWithBd;
obsData(:, 3) = data.BdWithEColiOnly;
obsData(:, 4) = data.EColiWithPhage;
obsData(:, 5) = data.PhageWithEColiOnly;
obsData(:, 6) = data.EColiAll;
obsData(:, 7) = data.BdAll;
obsData(:, 8) = data.PhageAll;

plotVals = getSpecies(paramVals, fixedVals, dataVals, simTimes, ...
    simMode, false);

fileName = [fileBase ' E coli only sim vs obs'];
plotSpecies(simTimes, plotVals(:, 1, 1:2), 'mb', ...
    {'Species enumerations', 'for E. coli only', ''}, false, fileName);

hold on
plot(simTimes, obsData(:, 1), 'bx')

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

fileName = [fileBase ' E coli and Bdellovibrio sim vs obs'];
plotSpecies(simTimes, plotVals(:, 2, 1:3), 'mbr', ...
    {'Species enumerations', 'for E. coli and Bdellovibrio', ''}, ...
    savePlot, fileName);

hold on
plot(simTimes, obsData(:, 2), 'bx')
plot(simTimes, obsData(:, 3), 'rx')

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

fileName = [fileBase ' E coli and Halophage sim vs obs'];
plotSpecies(simTimes, plotVals(:, 3, [1 2 4]), 'mbg', ...
    {'Species enumerations', 'for E. coli and Halophage', ''}, ...
    savePlot, fileName);

hold on
plot(simTimes, obsData(:, 4), 'bx')
plot(simTimes, obsData(:, 5), 'gx')

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

fileName = ...
    [fileBase ' E coli, Bdellovibrio and Halophage sim vs obs'];
plotSpecies(simTimes, plotVals(:, 4, 1:4), 'mbrg', ...
    {'Species enumerations', ...
    'for E. coli, Bdellovibrio and Halophage', ''}, savePlot, fileName);

hold on
plot(simTimes, obsData(:, 6), 'bx')
plot(simTimes, obsData(:, 7), 'rx')
plot(simTimes, obsData(:, 8), 'gx')

fig = gcf;

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end