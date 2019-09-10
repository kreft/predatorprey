function dy = NottinghamPhageN2PIIVIODE(t, y, sP)

% ODEs for two prey and two predators system
%
% Equations represent a batch system with an abiotic resource, prey species
% demonstrating monod kinetics, and two predators both exhibiting a 
% Holling type II functional response and each with seperate bdelloplast 
% / infected cell stage.
% simMode = 10
%
% function dy = NottinghamPhageN2PIIVIODE(t, y, sP)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  16/10/17 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
% 1.01		 J K Summers  08/10/18 Ongoing developement as well as initial  
% 								   phage resistance

% Initial numbers of individuals in species being modeled
sub = y(1);             % substrate value               in fg/ml
senPrey = y(2);         % Prey cells                    in cells / ml
phageResPrey = y(3);
bd = y(4);              % Bdellovibrio cells            in cells / ml
bdplast = y(5);         % Bdelloplasts                  in cells / ml
phage = y(6);           % Phage virions                 in virions / ml
infCell = y(7);         % Infected cells                in cells / ml

% Rates for processes
dSub = -(senPrey + phageResPrey) * sP.muMaxPrey * sub / ...
    ((sP.Ksn + sub) * sP.yieldNPerS) + ...
    sP.yieldSPerV * sP.kV * infCell + ...
    sP.yieldSPerP * sP.kP * bdplast;

% Bdellovibrio persistence is phenotypic so persitor bacteria divide to
% give sensitive bacteria
dSenPrey = senPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * senPrey / ((sP.Knp + senPrey + phageResPrey) * ...
    sP.yieldBPerN) - ...
    phage * sP.muMaxPred2 * senPrey / sP.yieldIPerN - ...
    senPrey * sP.rateDevResistance;

dPhageResPrey = phageResPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * phageResPrey / ...
    ((sP.Knp + senPrey + phageResPrey) * sP.yieldBPerN) + ...
    senPrey * sP.rateDevResistance;

dPred1 = sP.kP * bdplast - ...
    bd * sP.muMaxPred1 * (senPrey + phageResPrey) / ...
    ((sP.Knp + (senPrey + phageResPrey)) * ...
    sP.yieldBPerP) - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * (senPrey + phageResPrey) / ...
    (sP.Knp + senPrey + phageResPrey) - ...
    sP.kP * bdplast / sP.yieldPPerB;

dPred2 = sP.kV * infCell - ...
    phage * sP.muMaxPred2 * senPrey / sP.yieldIPerV;

dBdelloplast2 = phage * sP.muMaxPred2 * senPrey - ...
    sP.kV * infCell / sP.yieldVPerI;

%write results
dy = [dSub; dSenPrey; dPhageResPrey; dPred1; ...
    dBdelloplast1; dPred2; dBdelloplast2];

end
