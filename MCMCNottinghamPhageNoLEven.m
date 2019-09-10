function [abcParams, accepts] = ...
    MCMCNottinghamPhageNoLEven(protocolFile, dataFile, sucesses, ...
    reportWindow, acceptError, compMode, fitAll, savePlot)

% Run the MCMC progress to attempt to fit paramters for observed data.
% 
% Data and information on priors are read in from the data and protocol 
% files
%
% function abcParams = MCMCNottinghamPhageNoL(protocolFile, dataFile, 
%    tries, reportWindow, acceptError, compMode, fitAll, savePlot)
%
% abcParams     - The different parameter settings tried that passed the
% threshold for acceptance
% accepts       - The acceptance scores
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
% 1.00       J K Summers  10/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

tic
params = readtable(protocolFile);

numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);
curVals = log10(params.initVals(1: numParams));
fixedVals = params.fixedVals;

abcParams = [];

data = readtable(dataFile);

simTimes = data.times;
simMode = params.mode(1);
dataNoise = params.dataNoise(1);
plotTitle = [char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' AR' num2str(acceptError) ' I' num2str(sucesses) ...
     ' FA' num2str(fitAll) ' '];

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
accepts = [];
dataGaps = [];
invalidParams = zeros(numParams, 1);
i = 0;
bestVal = acceptError + 1;
inbounds = 0;
setTries = 0;
   
while i < sucesses
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
        
        if mod(inbounds, 100) == 0
            inbounds

            if inbounds > reportWindow
                currPer = (sum(accepts((inbounds - reportWindow):inbounds)) / ...
                    reportWindow) * 100
                tolPer = sum(accepts(1:inbounds) / inbounds) * 100
            end

        end
     
        % evaluate if data from the candidate values gives data within the
        % acceptable error range from the observed data.
        [tolerable, dataGap] = ...
            NottinghamPhageSimGrowth(10.^candVals, ...
            fixedVals, simTimes, obsData, dataNoise, simMode, compMode, ...
            fitAll, acceptError);
        
        inbounds = inbounds + 1;
        dataGaps(inbounds) = dataGap;

        if tolerable
            curVals = candVals;

            % store the acceptable values
            abcParams = [abcParams; 10.^curVals'];
            accepts(inbounds) = 1;
            
            if dataGap < bestVal
                bestVal = dataGap
                bestParams = 10.^curVals;
            end
            
            i = i + 1;
        else
            accepts(inbounds) = 0;
        end
        
    end

end
    
if sum(accepts) > 0
    plotGraphs(abcParams(size(abcParams, 1), :), simMode, fixedVals, ...
        simTimes, savePlot, plotTitle);
    plotHistograms(log10(abcParams), paramNames, true, savePlot, ...
        plotTitle);
    plotAcceptances(accepts, savePlot, plotTitle);
    plotParamsOutOfBounds(invalidParams, setTries, savePlot, plotTitle);
    plotGaps(dataGaps, savePlot, plotTitle);
    % plotAbcData(abcParams, paramNames, savePlot, plotTitle);
end

% invalidParams * 100 / setTries
sum(accepts) * 100 / sucesses

toc
end