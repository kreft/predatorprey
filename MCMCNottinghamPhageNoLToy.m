function [abcParams, accepts] = MCMCNottinghamPhageNoLToy(protocolFile, ...
    dataFile, tries, reportWindow, acceptError, compMode, fitAll, savePlot)

% Run the MCMC progress to attempt to fit paramters for toy data.
% 
% Data and information on priors are read in from the protocol file
% Toy data is generated from "True" values stored in the protocol file
%
% function abcParams = MCMCNottinghamPhageToy(protocolFile, tries, ...
%    acceptError, fitAll, savePlot, plotTitle)
%
% abcParams     - The different parameter settings tried that passed the
% threshold for acceptance
% accepts       - The acceptance scores
%
% protocolFile  - The data to plot and other parameters
% tries         - The number of parameter settings to try
% acceptError   - Factor by which to adjust parameter acceptance threshold
% compMode      - How should simulated and observed data be compared?
% fitAll        - If False do not fit 2 predator data set.
% savePlot      - Should the plots be saved

% Version    Author       Date      Affiliation
% 1.00       J K Summers  09/06/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

tic
params = readtable(protocolFile);

numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);
curVals = log10(params.initVals(1: numParams));
fixedVals = params.fixedVals;
trueVals = params.trueVals;

% put these values into the output matrix
abcParams(1, :) = 10.^curVals;
   
data = readtable(dataFile);

simTimes = data.times;
simMode = params.mode(1);
dataNoise = params.dataNoise(1);
plotTitle = ['Toy ' char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' AR' num2str(acceptError) ' I' num2str(tries) ' FA' num2str(fitAll)];

obsData = getAndPlotSpecies(trueVals, fixedVals, dataNoise, ...
    simTimes, simMode, savePlot, plotTitle);

sigmaMove = params.sigmaMove(1:numParams);
minPrior = log10(params.minPrior);
maxPrior = log10(params.maxPrior);
accepts = zeros(tries, 1);
invalidParams = zeros(numParams, 1);
   
for i = 2:tries
    
    if mod(i, 10) == 0
        i
        
        if i > reportWindow
            (sum(accepts((i-reportWindow):i)) / reportWindow) * 100
        end
        
    end
     
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
        % evaluate if data from the candidate values gives data within the
        % acceptable error range from the observed data.
        tolerable = NottinghamPhageSimGrowth(10.^candVals, ...
            fixedVals, simTimes, obsData, dataNoise, simMode, compMode, ...
            fitAll, acceptError);

        if tolerable
            curVals = candVals;

            % store the acceptable values
            abcParams = [abcParams; 10.^curVals'];
            accepts(i) = 1;
        end

    end

end
    
plotGraphs(10.^curVals, simMode, fixedVals, simTimes, savePlot, plotTitle);
plotHistograms(log10(abcParams), paramNames, savePlot, plotTitle);
% plotAbcData(abcParams, paramNames, savePlot, plotTitle);
invalidParams * 100 / tries
sum(accepts) * 100 / tries

toc
end