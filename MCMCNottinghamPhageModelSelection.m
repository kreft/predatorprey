function [abcParams, paramNames] = ...
    MCMCNottinghamPhageModelSelection(protocolFile, dataFile, tries, ...
    reportWindow, acceptError, compMode, fitAll, savePlot)
 
% Run the MCMC process with model selection
% 
% Data and information on priors are read in from the data and protocol 
% files
%
% function [abcParams, paramNames] = ...
%     MCMCNottinghamPhageModelSelection(protocolFile, dataFile, tries, ...
%     reportWindow, acceptError, compMode, fitAll, savePlot)
%
% abcParams     - The parameters that gave results within tolerance
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
% 1.00       J K Summers  11/11/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
 
tic
params = readtable(protocolFile);

numModels = params.numModels(1);
j = 1;

for i = 1:numModels
    numParams(i) = params.numParams(i);
    paramNames(i) = params.paramNames(j: j + numParams(i) - 1);
    outputVals(i) = paramNames(i)';

    % initial values
    curVals(i, :) = log10(params.initVals(1: j + numParams(i) - 1));
    fixedVals(i, :) = params.fixedVals(1: j + numParams(i) - 1);
    minPriors(i, :) = log10(params.minPrior(1: j + numParams(i) - 1));
    maxPriors(i, :) = log10(params.maxPrior(1: j + numParams(i) - 1));
    sigmaMove(i, :) = params.sigmaMove(1:j + numParams(i) - 1);
    j = j + numParams(i);
end
   
abcParams = [];
dataGapsS = [];
dataGapsD = [];
totAccepted = 0;
modelsAccepted = zeros(numModels);
  
data = readtable(dataFile);
 
simTimes = data.times;
dataNoise = params.dataNoise(1);
plotTitle = [char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' AR' num2str(acceptError) ' I' num2str(tries) ...
     ' FA' num2str(fitAll) ' '];
 
obsData(:, 1) = data.EColiOnly;
obsData(:, 2) = data.EColiWithBd;
obsData(:, 3) = data.BdWithEColiOnly;
obsData(:, 4) = data.EColiWithPhage;
obsData(:, 5) = data.PhageWithEColiOnly;
obsData(:, 6) = data.EColiAll;
obsData(:, 7) = data.BdAll;
obsData(:, 8) = data.PhageAll;
 
simModes = params.numModes;
accepts = zeros(tries, 1);
dataGaps = NaN(tries, 1);
i = 1;
setTries = 0;
bestVal = acceptError + 1;
   
while i < tries
    simMode = randi(simModes);
    setTries = setTries + 1;
    validParams = true;
    candVals = curVals;
    
    % update each parameter
    for j = 1:numParams(simMode)
        
        % propose a new value from a normal range
        candVals(simMode, j) = ...
            normrnd(curVals(simMode, j), sigmaMove(simMode, j));
 
        if (candVals(simMode, j) < minPrior(simMode, j)) || ...
                (candVals(simMode, j) > maxPrior(simMode, j))
            validParams = false;
            break;
        end
        
    end
    
    if validParams
        paramVals = 10.^candVals(simMode, j);
 
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
            fixedVals(simMode, :), simTimes, obsData, dataNoise, ...
            simMode, compMode, fitAll, acceptError);
        
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
            valParams = [simMode paramVals'];
            
            % store the acceptable values
            abcParams = [abcParams; valParams];
            totAccepted = totAccepted + 1;
            modelsAccepted(simMode) = modelsAccepted(simMode) + 1;
            speciesVals(totAccepted, :, :, :) = curSpecies;
            outputVals = [outputVals; num2cell(valParams)];
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

if sum(accepts) > 0
%     plotGraphs(mean(abcParams), simMode, fixedVals, ...
%         simTimes, savePlot, plotTitle);
%     plotHistograms(log10(abcParams), minPrior, maxPrior, paramNames, ...
%         true, savePlot, plotTitle);
    plotAcceptances(accepts, savePlot, plotTitle);
%     plotParamsOutOfBounds(invalidParams, setTries, savePlot, plotTitle);
    plotModelGaps(dataGaps, abcParams(:, 1), savePlot, plotTitle);
    plotModelSel(modelsAccepted, savePlot, plotTitle);
    passGaps = dataGaps;
    passGaps(passGaps > acceptError) = NaN;
    plotModelGaps(passGaps, abcParams(:, 1), savePlot, ...
        [plotTitle ' Passes ']);
    % plotAbcData(abcParams, paramNames, savePlot, plotTitle);
%     NottinghamPlotSeries(speciesVals, simTimes, ...
%         false, acceptError, dataGapsD, savePlot, plotTitle)
    
    xlwrite([plotTitle ' Params'], outputVals);
    xlwrite([plotTitle ' Accepted distances'], dataGapsS);
    xlwrite([plotTitle ' All distances'], dataGapsD);
end

% invalidParams * 100 / setTries
sum(accepts) * 100 / tries
toc
end

