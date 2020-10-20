function NottinghamPhageSensitivityAnalysis(paramFile, simMode, ...
    compMode, fixedVals, dataVals, dataNoise, varyPercent, fitAll, ...
    fileBase)

% Read in a set of parameters and perform a base line simulation, then
% compare to simulations with initial species densities varied
% 
% NottinghamPhageSensitivityAnalysis(paramFile, simMode, fixedVals, ...
%    dataVals, dataNoise, varyPercent, fileBase)
%
% paramFile     - File with parameters for simulation
% simMode       - Which ODE equations should be used
% compMode      - How should simulated and observed data be compared?
% fixedVals     - Some values which are not changed
% dataVals		- Initial species values
% dataNoise     - How noisy do we believe the data to be?
% varyPercent   - By what percentage should parameters be varied?
% fitAll        - Should simulations be fitted to single predator only data
%                 or all data
% fileBase      - Base filename for all data from this analysis

% Version    Author       Date      Affiliation
% 1.00       J K Summers  12/11/19  Kreft Lab - School of Biosciences -
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

fileParamsTab = readtable(paramFile);
outputVals = [{'Base'}; {'U 01'}; {'D 01'}; {'U 02'}; {'D 02'}; ...
    {'U 03'}; {'D 03'}; {'U 04'}; {'D 04'}; {'U 05'}; {'D 05'}; ...
    {'U 06'}; {'D 06'}; {'U 07'}; {'D 07'}; {'U 08'}; {'D 08'}]';

fileParams = table2array(fileParamsTab);

for paramInd = 1:1000 %size(fileParams, 1)
    [~, ~, dataGapBase, ~] = ...
        NottinghamPhageSimGrowth(10.^fileParams(paramInd, :), ...
        fixedVals, dataVals, simTimes, obsData, dataNoise, simMode, ...
        compMode, fitAll, 1000);
    
    outputData = num2cell(dataGapBase);
    
    for varyInd = 1:size(dataVals, 1)
        varyData = dataVals;
%         varyData(varyInd) = 10^(log10(varyData(varyInd)) * ...
%             (1 + varyPercent/100));
        varyData(varyInd) = 10^(log10(dataVals(varyInd)) + 1);
        
        [~, ~, dataGapUp, ~] = ...
            NottinghamPhageSimGrowth(10.^fileParams(paramInd, :), ...
            fixedVals, varyData, simTimes, obsData, dataNoise, simMode, ...
            compMode, fitAll, 1000);
        outputData = [outputData num2cell(dataGapUp)];
        
%         varyData(varyInd) = 10^(log10(dataVals(varyInd)) * ...
%             (1 - varyPercent/100));
        varyData(varyInd) = 10^(log10(dataVals(varyInd)) - 1);
        
        [~, ~, dataGapDown, ~] = ...
            NottinghamPhageSimGrowth(10.^fileParams(paramInd, :), ...
            fixedVals, varyData, simTimes, obsData, dataNoise, simMode, ... 
            compMode, fitAll, 1000);
        outputData = [outputData num2cell(dataGapDown)];
    end
    
    outputVals = [outputVals; outputData];
end

try
    xlwrite(fileBase, outputVals);
catch
                
    try
        xlswrite(fileBase, outputVals);
    catch
    end
                
end          

end