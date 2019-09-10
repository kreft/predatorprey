function dy = TestStatODE(t, y, dR)

% ODEs for a prey and two predators system
%
% Equations represent a batch system with an abiotic resource, prey species
% demonstrating monod kinetics, some of which have / develop ...
% resistence / persistence vs predation and two predators both ...
% exhibiting a Holling type II functional response and each with a 
% seperate bdelloplast / infected cell stage.
%
% function dy = TestStatODE(t, y, dR)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  15/05/17 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Initial numbers of individuals in species being modeled
bd = y(1);              % Bdellovibrio cells            in cells / ml

dPred = - dR * bd;

%write results
dy = [dPred];

end
