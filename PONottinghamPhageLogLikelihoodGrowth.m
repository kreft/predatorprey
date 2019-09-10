function logLikely = PONottinghamPhageLogLikelihoodGrowth(theta, ...
    simTimes, obsVals, sigmaData)
   
% The likelihood of getting the observed data with these parameters.
% 
% This is a simplified prey only version 
%
% function logLikely = PONottinghamPhageLogLikelihoodGrowth(theta, ...
%    simTimes, obsVals, sigmaData)
%
% theta     - The parameters being checked
% simTimes  - The times for which we have observed data
%
% Version    Author       Date      Affiliation
% 1.00       J K Summers  02/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

% count how many observations we have got
numObs = length(simTimes);

options = odeset('RelTol', 1e-09, 'AbsTol', 1e-09);

initVals(1) = theta(1);
initVals(2) = theta(2);

thetaODE.muMaxPrey = theta(3);
thetaODE.Ksn = theta(4);
thetaODE.yieldNPerS = theta(5);

% create a vector with NAs to store the solution of the ODE at each 
% time point
predVals = NaN(numObs, 2);

[~, predVals] = ode45(@NottinghamPhageN1NoPredODE, simTimes, initVals, ...
    options, thetaODE);

sData = find(isnan(predVals(:, 2)));
oData = find(isnan(obsVals));

logLikely = (-0.5 / (sigmaData^2)) * sum((sData - oData).^2);

end