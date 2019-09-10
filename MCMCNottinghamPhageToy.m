function abcParams = MCMCNottinghamPhageToy(protocolFile, dataFile, ...
    tries, acceptError, compMode, fitAll, savePlot)

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
curVals = params.initVals(1: numParams);
fixedVals = params.fixedVals;
trueVals = params.trueVals;

% put these values into the output matrix
abcParams(1, :) = curVals;
   
data = readtable(dataFile);

simTimes = data.times;
simMode = params.mode(1);
dataNoise = params.dataNoise(1);
plotTitle = ['Toy ' char(params.plotName(1)) char(params.trueTitles(1)) ...
     ' AR' num2str(acceptError) ' I' num2str(tries) ' FA' num2str(fitAll)];

obsData = getAndPlotSpecies(trueVals, fixedVals, dataNoise, ...
    simTimes, simMode, savePlot, plotTitle);

sigmaMove = params.sigmaMove(1:numParams);
sigmaPrior = params.sigmaPrior;
prior = params.prior;
   
% evalute the log-likelihood at the current of the parameters
[logCurLikely, timeOut] = ...
    NottinghamPhageLogLikelihoodGrowth(curVals, fixedVals, ...
    simTimes, obsData, dataNoise, simMode, compMode, fitAll);
                
for j = 1:numParams
    % do the same but for the current value
    logLikeyPriorCur(j) = log(normpdf(curVals(j), prior(j), ...
        sigmaPrior(j)));
end

for i = 2:tries
    
    if mod(i, 10) == 0
        i
    end
      
    % update each parameter
    for j = 1:numParams
        candVals = curVals;
        
        % propose a new value from a normal range
        candVals(j) = normrnd(curVals(j), sigmaMove(j));

        if candVals(j) > 0
            % evaluate the log-likelihood at the candidate value
            [logCandLikely, timeOut] = ...
                NottinghamPhageLogLikelihoodGrowth(candVals, ...
                fixedVals, simTimes, obsData, dataNoise, simMode, ...
                compMode, fitAll);

            if ~timeOut
                % If we have timed out then the candidate values should
                % automatically be rejected

                % evaluate the log prior density, i.e. the density of a 
                % Normal distribution centered on prior(j), with a sigma 
                % of prior.sigma(j)
                logLikelyPriorCand = log(normpdf(candVals(j), prior(j), ...
                    sigmaPrior(j)));

                % evaluate the log numerator and log denominator of the
                % M-H ratio
                logLikelyTotCand = logCandLikely + logLikelyPriorCand;
                logLikeyTotCur = logCurLikely + logLikeyPriorCur(j);

                % accept reject mechanism
                accept = rand;

                if log(accept) < (logLikelyTotCand - logLikeyTotCur) * ...
                    acceptError
                    curVals(j) = candVals(j);
                    logCurLikely = logCandLikely;
                    logLikeyPriorCur(j) = logLikelyPriorCand;
                end
                
            end

        end

    end

    % store the output
    abcParams(i, :) = curVals;
end
    
plotGraphs(curVals, simMode, fixedVals, simTimes, savePlot, plotTitle);
plotAbcData(abcParams, paramNames, savePlot, plotTitle);
toc
end