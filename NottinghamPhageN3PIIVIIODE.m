function dy = NottinghamPhageN3PIIVIIODE(t, y, sP)

% ODEs for a prey and two predators system
% Equations represent a batch system with an abiotic resource, single prey
% demonstrating monod kinetics and two predators both exhibiting a Holling
% type II functional response and each with a seperate bdelloplast stage.
% simMode = 1
%
% function dy = NottinghamPhageN3PIIVIIODE(t, y, sP)
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
sub = y(1);         % substrate value         in fg / ml
senPrey = y(2);     % numbers of prey 1       in cells / ml
bdResPrey = y(3);
phResPrey = y(4);
resPrey = y(5);
bd = y(6);          % numbers of predator 1   in cells / ml
bdplast = y(7);     % amount of bdelloplast 1 in cells / ml
phage = y(8);       % numbers of predator 2   in cells / ml
infCell = y(9);     % amount of bdelloplast 2 in cells / ml

% Rates for processes
dSub = -(senPrey + bdResPrey + phResPrey + resPrey) * ...
    sP.muMaxPrey * sub / ((sP.Ksn + sub) * sP.yieldNPerS);

dSenPrey = senPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * senPrey / ...
    ((sP.Knp + senPrey) * sP.yieldBPerN) - ...
    phage * sP.muMaxPred2 * senPrey / ...
    ((sP.Knv + senPrey) * sP.yieldIPerN);

dBdResPrey = bdResPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    phage * sP.muMaxPred2 * bdResPrey / ...
    ((sP.Knv + bdResPrey) * sP.yieldIPerN);

dPhResPrey = phResPrey * (sP.muMaxPrey * sub) / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * phResPrey / ...
    ((sP.Knp + phResPrey) * sP.yieldBPerN);

dResPrey = resPrey * sP.muMaxPrey * sub / (sP.Ksn + sub);

dPred1 = sP.kP * bdplast - ...
    bd * sP.muMaxPred1 * (senPrey + phResPrey) / ...
    ((sP.Knp + senPrey + phResPrey) * sP.yieldBPerP) - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * (senPrey + phResPrey) / ...
    (sP.Knp + senPrey + phResPrey) - ...
    sP.kP * bdplast / sP.yieldPPerB;

dPred2 = sP.kV * infCell - ...
    phage * sP.muMaxPred2 * (senPrey + bdResPrey) / ...
    ((sP.Knv + senPrey + bdResPrey) * sP.yieldIPerV);

dBdelloplast2 = phage * (sP.muMaxPred2 * (senPrey + bdResPrey)) / ...
    (sP.kV + senPrey + bdResPrey) - ...
    sP.kV * infCell / sP.yieldVPerI;

%write results
dy = [dSub; dSenPrey; dBdResPrey; dPhResPrey; dResPrey; dPred1; ...
    dBdelloplast1; dPred2; dBdelloplast2];

end
