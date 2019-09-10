function dy = NottinghamPhageN3IPIVIODE(t, y, sP)

% ODEs for a prey and two predators system
%
% Equations represent a batch system with an abiotic resource, prey species
% demonstrating monod kinetics, some of which show resistance vs predation,
% others which develop or lose persistance to predation and two predators 
% both exhibiting a Holling type I functional response, one with mortality
% and each with a seperate bdelloplast / infected cell stage.
% simMode = 12
%
% function dy = NottinghamPhageN3IPIVIODE(t, y, sP)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  24/11/17 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Initial numbers of individuals in species being modeled
sub = y(1);             % substrate value               in fg/ml
senPrey = y(2);         % Sensitive cells               in cells / ml
bdPersistPrey = y(3);   % Bdellovibrio persistor cells  in cells / ml
phageResPrey = y(4);    % phage resistant cells         in cells / ml
bd = y(5);              % Bdellovibrio cells            in cells / ml
bdplast = y(6);         % Bdelloplasts                  in cells / ml
phage = y(7);           % Phage virions                 in virions / ml
infCell = y(8);         % Infected cells                in cells / ml

% Rates for processes
dSub = -(senPrey + phageResPrey + bdPersistPrey * sP.persGrowth) * ...
    sP.muMaxPrey * sub / ((sP.Ksn + sub) * sP.yieldNPerS) + ...
    sP.yieldSPerV * sP.kV * infCell + ...
    sP.yieldSPerP * sP.kP * bdplast;

% Bdellovibrio persistence is phenotypic so persistor and sensitive 
% bacteria divide to convert and revert
dSenPrey = senPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * senPrey / sP.yieldBPerN - ...
    phage * sP.muMaxPred2 * senPrey / sP.yieldIPerN - ...
    senPrey * sP.rateDevPersist + ...
    bdPersistPrey * sP.rateRevert;

dBdPersistPrey = bdPersistPrey * sP.muMaxPrey * sP.persGrowth * sub / ...
    (sP.Ksn + sub) - ...
    phage * sP.muMaxPred2 * bdPersistPrey / sP.yieldIPerN + ...
    senPrey * sP.rateDevPersist - ...
    bdPersistPrey * sP.rateRevert;

dPhageResPrey = phageResPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * phageResPrey / sP.yieldBPerN;

dPred1 = sP.kP * bdplast - ...
    bd * sP.muMaxPred1 * (senPrey + phageResPrey) / sP.yieldBPerP - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * (senPrey + phageResPrey) - ...
    sP.kP * bdplast / sP.yieldPPerB;

dPred2 = sP.kV * infCell - ...
    phage * sP.muMaxPred2 * (senPrey + bdPersistPrey) / sP.yieldIPerV;

dBdelloplast2 = phage * sP.muMaxPred2 * (senPrey + bdPersistPrey) - ...
    sP.kV * infCell / sP.yieldVPerI;

%write results
dy = [dSub; dSenPrey; dBdPersistPrey; dPhageResPrey; dPred1; ...
    dBdelloplast1; dPred2; dBdelloplast2];

end
