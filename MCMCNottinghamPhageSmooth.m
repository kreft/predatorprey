function abcParams = MCMCNottinghamPhageSmooth(protocolFile, tries, ...
    acceptError, compMode, fitAll, windowWidth, savePlot, plotTitle)

% Run the MCMC progress to attempt to fit paramters for the data.
% 
% Data and information on priors are read in from the protocol file
%
% function abcParams = MCMCNottinghamPhage(protocolFile, tries, ...
%    acceptError, savePlot)
%
% abcParams     - The different parameter settings tried that passed the
% threshold for acceptance
%
% protocolFile  - The data to plot
% tries         - The number of parameter settings to try
% acceptError   - Factor by which to adjust parameter acceptance threshold
% fitAll        - If False do not fit 2 predator data set.
% savePlot      - Should the plots be saved

% Version    Author       Date      Affiliation
% 1.00       J K Summers  02/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

params = readtable(protocolFile);

numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);
curVals = params.initVals(1: numParams);
fixedVals = params.fixedVals;

% put these values into the output matrix
abcParams(1, :) = curVals;
   
simTimes = params.times;

obsData(:, 1) = params.EColiOnly;
obsData(:, 2) = params.EColiWithBd;
obsData(:, 3) = params.BdWithEColiOnly;
obsData(:, 4) = params.EColiWithPhage;
obsData(:, 5) = params.PhageWithEColiOnly;
obsData(:, 6) = params.EColiAll;
obsData(:, 7) = params.BdAll;
obsData(:, 8) = params.PhageAll;

sigmaData = params.sigmaData(1);
dataNoise = params.dataNoise(1);

sigmaMove = params.sigmaMove(1:numParams);
sigmaPrior = params.sigmaPrior;
prior = params.prior;
simMode = params.mode(1);
   
% evalute the log-likelihood at the current of the parameters
logCurLikely = ...
    NottinghamPhageLogLikelihoodGrowth(curVals, fixedVals, ...
    simTimes, obsData, sigmaData, simMode, compMode, fitAll);

i = 1;
converged = false;
                
while ((i < tries) && ~converged)
    i = i + 1;
      
    % update each parameter
    for j = 1:numParams
        candVals = curVals;
        
        % propose a new value from a normal range
        candVals(j) = normrnd(curVals(j), sigmaMove(j));

        if candVals(j) > 0
            % evaluate the log-likelihood at the candidate value
            logCandLikely = ...
                NottinghamPhageLogLikelihoodGrowth(candVals, ...
                fixedVals, simTimes, obsData, sigmaData, simMode, ...
                compMode, fitAll);

            % evaluate the log prior density, i.e. the density of a 
            % Normal distribution centered on prior(j), with a sigma 
            % of prior.sigma(j)
            logPriorCand = log(normpdf(candVals(j), prior(j), ...
                sigmaPrior(j)));

            % do the same but for the current value
            logPriorCur = log(normpdf(curVals(j), prior(j), ...
                sigmaPrior(j)));

            % evaluate the log numerator and log denominator of the
            % M-H ratio
            logPriorCand = logCandLikely + logPriorCand;
            logPriorCur = logCurLikely + logPriorCur;

            % accept reject mechanism
            accept = rand;

            if log(accept) < (logPriorCand - logPriorCur) * ...
                acceptError
                curVals(j) = candVals(j);
                logCurLikely = logCandLikely;
            end

        end

    end
      
    % store the output
    abcParams(i, :) = curVals;
    
    if i > windowWidth
        smoothParams(i - windowWidth, :) = ...
            medianWindow(abcParams((i - windowWidth) : i, :));
        
        if i > (windowWidth + 10)
            converged = SteadyState(1:(i - windowWidth), smoothParams);
        end
        
        if converged
            i = 1;
        end
        
    end
    
end

plotGraphs(curVals, simMode, fixedVals, simTimes, savePlot, plotTitle);
plotAbcData(abcParams, paramNames, savePlot, plotTitle);
end