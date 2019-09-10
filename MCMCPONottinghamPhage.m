function abcParams = MCMCPONottinghamPhage(protocolFile, tries, ...
    acceptError, savePlot)

% MCMC ABC searching for parameters which explain the observed data well.
% 
% This is a simplified prey only version 
%
% function abcParams = MCMCPONottinghamPhage(protocolFile, tries, ...
%    acceptError, savePlot)
%
% abcParams     - The different parameter settings tried that passed the
% threshold for acceptance
%
% protocolFile  - The data to plot
% tries         - The number of parameter settings to try
% acceptError   - Factor by which to adjust parameter acceptance threshold
% savePlot      - Should the plots be saved
%
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

sigmaData = params.sigmaData(1);
sigmaMove = params.sigmaMove(1:numParams);
sigmaPrior = params.sigmaPrior;
prior = params.prior;

% evalute the log-likelihood at the current of the parameters
logCurLikely = ...
    PONottinghamPhageLogLikelihoodGrowth(curVals, simTimes, ...
    obsData, sigmaData, plotData);
                
for i = 2:tries

    % update each parameter
    for j = 1:numParams

        candVals = curVals;
        % propose a new value from a normal range
        candVals(j) = normrnd(curVals(j), sigmaMove(j));

        if candVals(j) > 0
            % evaluate the log-likelihood at the candidate value
            logCandLikely = ...
                PONottinghamPhageLogLikelihoodGrowth(candVals, ...
                simTimes, obsData, sigmaData, plotData);

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
end

end