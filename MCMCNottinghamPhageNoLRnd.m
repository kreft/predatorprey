function [abcParams, accepts, dataGapsR, dataGapsR2] = ...
    MCMCNottinghamPhageNoLRnd(protocolFile, dataFile, tries, ...
    starts, reportWindow, acceptError, compMode, fitAll, savePlot)
 
% Run the MCMC progress to attempt to fit paramters for observed data.
% 
% Data and information on priors are read in from the data and protocol 
% files
%
% function [abcParams, accepts, dataGapsR, dataGapsR2] = ...
%     MCMCNottinghamPhageNoL(protocolFile, dataFile, tries, ...
%     reportWindow, acceptError, compMode, fitAll, savePlot)
%
% abcParams     - The different parameter settings tried that passed the
% threshold for acceptance
% accepts       - The acceptance scores
% dataGapsR     - Gaps between simulated and observed data for accepted 
% parameters
% dataGapsS2    - Gaps between all simulated and observed data for 
% accepted parameters
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
% 1.00       J K Summers  18/10/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%
 
tic
params = readtable(protocolFile);
 
numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);

minPrior = log10(params.minPrior(1: numParams));
maxPrior = log10(params.maxPrior(1: numParams));
fixedVals = params.fixedVals;
 
abcParams = [];
dataGapsR = [];
dataGapsR2 = [];
  
data = readtable(dataFile);
 
simTimes = data.times;
simMode = params.mode(1);
dataNoise = params.dataNoise(1);

plotTitle = [char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' Dual gap multi start AR' num2str(acceptError) ...
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
accepts = zeros(tries * starts, 1);
dataGaps = zeros(tries * starts, 1);
invalidParams = zeros(numParams, 1);
bestVal = acceptError + 1;
points = lhsdesign(numParams, starts);

for k = 1:starts
    initValues = minPrior + points(:, k) .* (maxPrior - minPrior);

    curVals = initValues;
    i = 2;
    setTries = 0;
   
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
 
            if mod(i, 100) == 0
                (k - 1) * tries + i
 
                if i > reportWindow
                    currPer = ...
                        (sum(accepts(((k - 1) * tries + i - reportWindow):((k - 1) * tries + i))) / ...
                        reportWindow) * 100
                    tolPer = sum(accepts) / ((k - 1) * tries + i) * 100
                end
 
            end
     
            % evaluate if data from the candidate values gives data within the
            % acceptable error range from the observed data.
            [tolerable, dataGap, dataGap2] = ...
                NottinghamPhageSimGrowth(10.^candVals, ...
                fixedVals, simTimes, obsData, dataNoise, simMode, compMode, ...
                fitAll, acceptError);
        
            if fitAll

                if dataGap2 > 100
                    largeGap = true;
                end

                dataGaps((k - 1) * tries + i) = dataGap2;
            else
            
                if dataGap > 100
                    largeGap = true;
                end
            
                dataGaps((k - 1) * tries + i) = dataGap;
            end
         
            if tolerable
                curVals = candVals;

                % store the acceptable values
                abcParams = [abcParams; 10.^curVals'];
                dataGapsR = [dataGapsR; dataGap];
                dataGapsR2 = [dataGapsR2; dataGap2];
                accepts((k - 1) * tries + i) = 1;

                if fitAll

                    if dataGap2 < bestVal
                        bestVal = dataGap2;
                        bestParams = 10.^curVals;
                    end

                else
                
                    if dataGap < bestVal
                        bestVal = dataGap;
                        bestParams = 10.^curVals;
                    end

                end
            
            end
        
            i = i + 1;
        end
        
    end
 
end
    
if sum(accepts) > 0
    plotGraphs(abcParams(size(abcParams, 1), :), simMode, fixedVals, ...
        simTimes, savePlot, plotTitle);
    plotHistograms(log10(abcParams), paramNames, false, savePlot, ...
        plotTitle);
    plotAcceptances(accepts, savePlot, plotTitle);
    plotParamsOutOfBounds(invalidParams, setTries, savePlot, plotTitle);
    plotGaps(dataGaps, savePlot, plotTitle);
    % plotAbcData(abcParams, paramNames, savePlot, plotTitle);
    NottinghamPlotSeries(abcParams, protocolFile, simTimes, ...
        false, acceptError, dataGapsR2, savePlot, plotTitle)
end
 
% invalidParams * 100 / setTries
sum(accepts) * 100 / tries
 
toc
end

