function dy = NottinghamPhageN1PIIVIODE(t, y, sP)

% ODEs for a single prey and two predators system
%
% Equations represent a batch system with an abiotic resource, prey species
% demonstrating monod kinetics, and two predators both exhibiting a 
% Holling type II functional response and each with seperate bdelloplast 
% / infected cell stage.
% simMode = 9
%
% function dy = NottinghamPhageN1PIIVIODE(t, y, sP)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  16/10/17 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Initial numbers of individuals in species being modeled
sub = y(1);             % substrate value               in fg/ml
prey = y(2);            % Prey cells                    in cells / ml
bd = y(3);              % Bdellovibrio cells            in cells / ml
bdplast = y(4);         % Bdelloplasts                  in cells / ml
phage = y(5);           % Phage virions                 in virions / ml
infCell = y(6);         % Infected cells                in cells / ml

% Rates for processes
dSub = -prey * sP.muMaxPrey * sub / ((sP.Ksn + sub) * sP.yieldNPerS) + ...
    sP.yieldSPerV * sP.kV * infCell + ...
    sP.yieldSPerP * sP.kP * bdplast;

dPrey = prey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * prey / ((sP.Knp + prey) * sP.yieldBPerN) - ...
    phage * sP.muMaxPred2 * prey / sP.yieldIPerN;

dPred1 = sP.kP * bdplast - ...
    bd * sP.muMaxPred1 * prey / ((sP.Knp + prey) * sP.yieldBPerP) - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * prey / (sP.Knp + prey) - ...
    sP.kP * bdplast / sP.yieldPPerB;

dPred2 = sP.kV * infCell - ...
    phage * sP.muMaxPred2 * prey / sP.yieldIPerV;

dBdelloplast2 = phage * sP.muMaxPred2 * prey - ...
    sP.kV * infCell / sP.yieldVPerI;

%write results
dy = [dSub; dPrey; dPred1; dBdelloplast1; dPred2; dBdelloplast2];

end
