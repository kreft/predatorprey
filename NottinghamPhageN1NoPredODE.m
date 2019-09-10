function dy = NottinghamPhageN1NoPredODE(t, y, sP)

% ODEs for a prey and two predators chemostat system
% Equations represent a chemostat with an abiotic resource, single prey
% demonstrating monod kinetics and two predators both exhibiting a Holling
% type II functional response and each with a seperate bdelloplast stage.
%
% function dy = NottinghamPhageN1NoPredODE(t, y, sP)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  11/09/16 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Initial numbers of individuals in species being modeled
sub = y(1);       % substrate value         in mg/ml
prey = y(2);

% Rates for processes
dSub = - prey * sP.muMaxPrey * sub / ((sP.Ksn + sub) * sP.yieldNPerS);

dPrey = prey * sP.muMaxPrey * sub / (sP.Ksn + sub);

%write results
dy = [dSub; dPrey];

end
