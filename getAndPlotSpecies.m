function dummyData = getAndPlotSpecies(simParams, fixedVals, ...
    dataNoise, simTimes, simMode, savePlot, fileBase)

% Create a set of dummy data based on parameters and plot it.
% 
% The y-axis should be a log scale. There will be four graphs
% 1. E. coli only
% 2. E. coli & Bdellovibrio
% 3. E. coli & halophage
% 4. E. coli, Bdellovibrio & halophage
%
% E. coli values are in blue, Bdellovibrio - red, halophage - yellow, 
% substrate pink
%
% function dummyData = getAndPlotSpecies(trueVals, fixedVals, 
%     dataNoise, simTimes, simMode, savePlot, fileBase)
%
% dummyData		- The data generated
%
% simParams     - The parameters for the simulation
% fixedVals		- Fixed values that do not vary
% dataNoise		- How noisy is the experimental data
% simTimes      - Time points for which data should be plotted.
% simMode       - Which ODE equations should be used
% savePlot      - Should plots be saved?
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  09/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

trueVals = getSpecies(simParams, fixedVals, simTimes, simMode);

dummyNoise = normrnd(1, dataNoise, ...
    [size(trueVals, 1), size(trueVals, 2), size(trueVals, 3)]);
dummyData = trueVals .* dummyNoise;
dummyData(dummyData < 1) = 1;
trueVals(trueVals < 1) = 1;

fileName = [fileBase ' Species enumerations for E. coli only true values'];
plotSpecies(simTimes, trueVals(:, 1, 2), 'b', ...
    {'Species enumerations', 'for E. coli only', ''}, savePlot, fileName);

fileName = [fileBase ...
    ' Species enumerations for E. coli and Bdellovibrio true values'];
plotSpecies(simTimes, trueVals(:, 2, 2:3), 'br', ...
    {'Species enumerations', 'for E. coli and Bdellovibrio', ''}, ...
    savePlot, fileName);

fileName = [fileBase ...
    ' Species enumerations for E. coli and Halophage true values'];
plotSpecies(simTimes, trueVals(:, 3, [2 4]), 'bg', ...
    {'Species enumerations', 'for E. coli and halophage', ''}, ...
    savePlot, fileName);

fileName = [fileBase ...
    ' Species enumerations for E. coli, Bdellovibrio and Halophage true values'];
plotSpecies(simTimes, trueVals(:, 4, 2:4), 'brg', ...
    {'Species enumerations', ...
    'for E. coli, Bdellovibrio and Halophage', ''}, savePlot, fileName);

fileName = [fileBase ' Species enumerations for E. coli only dummy data'];
plotSpecies(simTimes, dummyData(:, 1, 2), 'b', ...
    {'Species enumerations', 'for E. coli only dummy data', ''}, ...
    savePlot, fileName);

fileName = [fileBase ...
    ' Species enumerations for E. coli and  Bdellovibrio  dummy data'];
plotSpecies(simTimes, dummyData(:, 2, 2:3), 'br', ...
    {'Species enumerations', ...
    'for E. coli and Bdellovibrio dummy data', ''}, ...
    savePlot, fileName);

fileName = [fileBase ...
    ' Species enumerations for E. coli and Halophage dummy data'];
plotSpecies(simTimes, dummyData(:, 3, [2 4]), 'bg', ...
    {'Species enumerations', 'for E. coli and halophage dummy data', ...
    ''}, savePlot, fileName);

fileName = [fileBase ...
    ' Species enumerations for E. coli, Bdellovibrio and Halophage dummy data'];
plotSpecies(simTimes, dummyData(:, 4, 2:4), 'brg', ...
    {'Species enumerations', ...
    'for E. coli, Bdellovibrio and Halophage dummy data', ''}, ...
    savePlot, fileName);
end