function abcParams = MCMCNottinghamPhageToySmooth(protocolFile, tries, ...
    acceptError, compMode, fitAll, windowWidth, savePlot, plotTitle)

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
% plotTitle     - Base file name for all plots

% Version    Author       Date      Affiliation
% 1.00       J K Summers  09/06/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

params = readtable(protocolFile);

numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);
curVals = params.initVals(1: numParams);
fixedVals = params.fixedVals;
trueVals = params.trueVals;

% put these values into the output matrix
abcParams(1, :) = curVals;
   
simTimes = params.times;
simMode = params.mode(1);
sigmaData = params.sigmaData(1);
dataNoise = params.dataNoise(1);

obsData = getAndPlotSpecies(trueVals, fixedVals, sigmaData, dataNoise, ...
    simTimes, simMode, savePlot, plotTitle);

sigmaMove = params.sigmaMove(1:numParams);
sigmaPrior = params.sigmaPrior;
prior = params.prior;
   
% evalute the log-likelihood at the current of the parameters
logCurLikely = ...
    NottinghamPhageLogLikelihoodGrowth(curVals, fixedVals, ...
    simTimes, obsData, dataNoise, simMode, compMode, fitAll);
allConverged = false;
converged = zeros(numParams, 1);
i = 2;
                
while (i <= tries) && ~allConverged
    
    if mod(i, 10) == 0
        i
    end
      
    % update each parameter
    for j = 1:numParams
        
        if ~converged(j)
            candVals = curVals;
        
            % propose a new value from a normal range
            candVals(j) = normrnd(curVals(j), sigmaMove(j));

            if candVals(j) > 0
                % evaluate the log-likelihood at the candidate value
                logCandLikely = ...
                    NottinghamPhageLogLikelihoodGrowth(candVals, ...
                    fixedVals, simTimes, obsData, dataNoise, simMode, ...
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

    end
      
    % store the output
    abcParams(i, :) = curVals;

    if i > windowWidth
        smoothParams(i - windowWidth, :) = ...
            medianWindow(abcParams((i - windowWidth) : i, :));
        
        if i > (windowWidth + 20)
            
            for j = 1:numParams
                
                if ~converged(j)
                    converged(j) = ...
                        SteadyState(1:(i - windowWidth), ...
                        smoothParams(:, j), 20);
                    
                    if converged(j)
                        a = 1;
                    end
                    
                end
                
            end
            
        end
        
        allConverged = ~sum(~converged);
    end
    
    i = i + 1;
end

plotGraphs(curVals, simMode, fixedVals, simTimes, savePlot, plotTitle);
plotAbcData(abcParams, paramNames, savePlot, plotTitle);
end