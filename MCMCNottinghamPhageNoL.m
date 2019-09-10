function [abcParams, paramWidths, SDParams, paramNames] = ...
    MCMCNottinghamPhageNoL(protocolFile, dataFile, tries, reportWindow, ...
    acceptError, compMode, fitAll, savePlot)
 
% Run the MCMC process to attempt to fit paramters for observed data.
% 
% Data and information on priors are read in from the data and protocol 
% files
%
% function [abcParams, paramWidths, SDParams, paramNames] = ...
%    MCMCNottinghamPhageNoL(protocolFile, dataFile, tries, reportWindow, ...
%    acceptError, compMode, fitAll, savePlot)
%
% abcParams     - The parameters that gave results within tolerance
% paramWidths   - Width of parameter
% SDParams      - SD of parameters
% paramNames    - Names of parameters
%
% protocolFile  - The parameters for the fitting process
% dataFile      - Data to fit to
% tries         - The number of parameter settings to try
% reportWindow  - Show acceptance percentage over the last this many tries
% acceptError   - Factor by which to adjust parameter acceptance threshold
% compMode      - How should simulated and observed data be compared?
% fitAll        - If False do not fit 2 predator data set.
% savePlot      - Should the plots be saved
 
% Version    Author       Date      Affiliation
% 1.00       J K Summers  31/08/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.01       J K Summers  27/10/17  Amended creating column titles for 
%                                   output files
%                                   store species values from accepted 
% parameter sets, pass these instead of parameters to 
% MCMCNottinghamPlotSeries
% 1.02       J K Summers  05/11/17  Pass back parameters, param names and 
%                                   file name 
%                                   
 
tic
warning off;
params = readtable(protocolFile);
 
numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);
outputVals = paramNames';

curVals = log10(params.initVals(1: numParams));
fixedVals = params.fixedVals;
 
abcParams = [];
dataGapsS = [];
dataGapsD = [];
totAccepted = 0;
  
data = readtable(dataFile);
 
simTimes = data.times;
simMode = params.mode(1);
dataNoise = params.dataNoise(1);
plotTitle = [char(params.plotName(1)) ' Mode ' num2str(simMode) ' ' ...
    char(params.trueTitles(1)) ' AR' num2str(acceptError) ...
    ' I' num2str(tries) ' FA' num2str(fitAll) ' '];
 
obsData(:, 1) = data.EColiOnly;
obsData(:, 2) = data.EColiWithBd;
obsData(:, 3) = data.BdWithEColiOnly;
obsData(:, 4) = data.EColiWithPhage;
obsData(:, 5) = data.PhageWithEColiOnly;
obsData(:, 6) = data.EColiAll;
obsData(:, 7) = data.BdAll;
obsData(:, 8) = data.PhageAll;
 
sigmaMove = params.sigmaMove(1:numParams);
minPrior = log10(params.minPrior);
maxPrior = log10(params.maxPrior);
accepts = zeros(tries, 1);
dataGaps = NaN(tries, 1);
invalidParams = zeros(numParams, 1);
i = 1;
setTries = 0;
bestVal = acceptError + 1;
   
while i < tries
    setTries = setTries + 1;
    validParams = true;
    candVals = curVals;
    
    % update each parameter
    for j = 1:numParams
        
        % propose a new value from a normal range
        candVals(j) = normrnd(curVals(j), sigmaMove(j));
 
        if (candVals(j) < minPrior(j)) || (candVals(j) > maxPrior(j))
            validParams = false;
            invalidParams(j) = invalidParams(j) + 1;
            break;
        end
        
    end
    
    if validParams
        paramVals = 10.^candVals;
 
        if mod(i, 100) == 0
            i
 
            if i > reportWindow
                currPer = (sum(accepts((i - reportWindow):i)) / ...
                    reportWindow) * 100
                tolPer = sum(accepts(1:i)) * 100 / i
            end
 
        end
     
        % evaluate if data from the candidate values gives data within the
        % acceptable error range from the observed data.
        [tolerable, dataGap, dataGap2, curSpecies] = ...
            NottinghamPhageSimGrowth(paramVals, ...
            fixedVals, simTimes, obsData, dataNoise, simMode, compMode, ...
            fitAll, acceptError);
        
        if fitAll
            
            if dataGap2 > 100
                largeGap = true;
            end
            
            dataGaps(i) = dataGap2;
        else
            
            if dataGap > 100
                largeGap = true;
            end
            
            dataGaps(i) = dataGap;
        end
        
 
        if tolerable
            curVals = candVals;
 
            % store the acceptable values
            abcParams = [abcParams; paramVals'];
            totAccepted = totAccepted + 1;
            speciesVals(totAccepted, :, :, :) = curSpecies;
            outputVals = [outputVals; num2cell(paramVals')];
            dataGapsS = [dataGapsS; dataGap];
            dataGapsD = [dataGapsD; dataGap2];
            accepts(i) = 1;
            
            if fitAll
                
                if dataGap2 < bestVal
                    bestVal = dataGap2;
                    bestParams = paramVals;
                end
                
            else
                
                if dataGap < bestVal
                    bestVal = dataGap;
                    bestParams = paramVals;
                end
                
            end
            
        end
        
        i = i + 1;
    end
 
end

paramWidths = NaN(1, numParams);
SDParams = NaN(1, numParams);

if sum(accepts) > 0
    
    if size(abcParams, 1) == 1
        plotGraphs(abcParams, simMode, fixedVals, simTimes, savePlot, ...
            plotTitle);
    else
        plotGraphs(mean(abcParams), simMode, fixedVals, ...
            simTimes, savePlot, plotTitle);
    end
    
%     plotHistograms(log10(abcParams), minPrior, maxPrior, paramNames, ...
%         true, savePlot, plotTitle);
    plotAcceptances(accepts, savePlot, plotTitle);
%     plotParamsOutOfBounds(invalidParams, setTries, savePlot, plotTitle);
    plotGaps(dataGaps, savePlot, plotTitle);
    passGaps = dataGaps;
    passGaps(passGaps > acceptError) = NaN;
    plotGaps(passGaps, savePlot, [plotTitle ' Passes ']);
    % plotAbcData(abcParams, paramNames, savePlot, plotTitle);
%     NottinghamPlotSeries(speciesVals, simTimes, ...
%         false, acceptError, dataGapsD, savePlot, plotTitle)
    
    xlwrite([plotTitle ' Params'], outputVals);
    
    for i = 1:numParams
        paramWidths(i) = max(log10(abcParams(:, i))) - ...
            min(log10(abcParams(:, i)));
        SDParams(i) = std(log10(abcParams(:, i)));
%         xlwrite([plotTitle ' Params'], paramWidths(i));
%         xlwrite([plotTitle ' Params'], SDParams(i));
    end
    
    xlwrite([plotTitle ' Accepted distances'], dataGapsS);
    xlwrite([plotTitle ' All distances'], dataGapsD);
end

% invalidParams * 100 / setTries
sum(accepts) * 100 / tries
toc
end

