function abcParams = MCMCNottinghamPhage(protocolFile, dataFile, tries, ...
    acceptError, compMode, fitAll, savePlot, plotTitle)

% Run the MCMC progress to attempt to fit paramters for the data.
% 
% Data and information on priors are read in from the protocol file
%
% function abcParams = MCMCNottinghamPhage(protocolFile, dataFile, tries, ...
%    acceptError, compMode, fitAll, savePlot, plotTitle)
%
% abcParams     - The different parameter settings tried that passed the
% threshold for acceptance
%
% protocolFile  - The parameters of the fitting process
% dataFile		- The experimental data to fit to
% tries         - The number of parameter settings to try
% acceptError   - Factor by which to adjust parameter acceptance threshold
% fitAll        - If False do not fit 2 predator data set.
% compMode		- What method is used to compare simulated and experimental
%				  data
% fitAll		- Should the fit be to all (true) or only single predator
%				  (false) data
% savePlot      - Should the plots be saved
% plotTitle		- Base name for plots

% Version    Author       Date      Affiliation
% 1.00       J K Summers  02/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

tic
params = readtable(protocolFile);

numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);
curVals = params.initVals(1: numParams);
fixedVals = params.fixedVals;

% put these values into the output matrix
abcParams(1, :) = curVals;   

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

sigmaData = params.sigmaData(1);
dataNoise = params.dataNoise(1);

sigmaMove = params.sigmaMove(1:numParams);
sigmaPrior = params.sigmaPrior;
prior = params.prior;
simMode = params.mode(1);
   
% evalute the log-likelihood at the current of the parameters
[logCurLikely, timeOut] = ...
    MCMCNottinghamPhageLogLikelihoodGrowth(curVals, fixedVals, ...
    simTimes, obsData, dataNoise, simMode, compMode, fitAll);

for j = 1:numParams
    % do the same but for the current value
    logLikeyPriorCur(j) = ...
        log(normpdf(curVals(j), prior(j), sigmaPrior(j)));
end

for i = 2:tries
      
    % update each parameter
    for j = 1:numParams
        candVals = curVals;
        
        % propose a new value from a normal range
        candVals(j) = normrnd(curVals(j), sigmaMove(j));

        if candVals(j) > 0
            % evaluate the log-likelihood at the candidate value
            [logCandLikely, timeOut] = ...
                MCMCNottinghamPhageLogLikelihoodGrowth(candVals, ...
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