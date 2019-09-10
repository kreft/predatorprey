function dy = NottinghamPhageN2PIIVIIODE(t, y, sP)

% ODEs for a prey and two predators system
%
% Equations represent a batch system with an abiotic resource, single prey
% demonstrating monod kinetics and two predators both exhibiting a Holling
% type II functional response and each with a seperate bdelloplast stage.
% simMode = 3
%
% function dy = NottinghamPhageN2PIIVIIODE(t, y, sP)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  11/05/16 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Initial numbers of individuals in species being modeled
sub = y(1);       % substrate value         in mg/ml
senPrey = y(2);   % numbers of prey 1       in mg dry mass/ml
resPrey = y(3);
bd = y(4);        % numbers of predator 1   in mg dry mass/ml
bdplast = y(5);   % amount of bdelloplast 1 in mg dry mass/ml
phage = y(6);     % numbers of predator 2   in mg dry mass/ml
infCell = y(7);   % amount of bdelloplast 2 in mg dry mass/ml

% Rates for processes
dSub = -(senPrey + resPrey) * sP.muMaxPrey * sub / ...
    ((sP.Ksn + sub) * sP.yieldNPerS) + ...
    sP.yieldSPerV * sP.kV * infCell + ...
    sP.yieldSPerP * sP.kP * bdplast;

dSenPrey = senPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * senPrey / ...
    ((sP.Knp + senPrey + resPrey) * sP.yieldBPerN) - ...
    phage * sP.muMaxPred2 * senPrey / ...
    ((sP.Knv + senPrey + resPrey) * sP.yieldIPerN);

dResPrey = resPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * resPrey / ...
    ((sP.Knp + senPrey + resPrey) * sP.yieldBPerN);

dPred1 = sP.kP * bdplast - ...
    bd * sP.muMaxPred1 * (senPrey + resPrey) / ...
    ((sP.Knp + (senPrey + resPrey)) * sP.yieldBPerP) - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * (senPrey + resPrey) / ...
    (sP.Knp + (senPrey + resPrey)) - ...
    sP.kP * bdplast / sP.yieldPPerB;

dPred2 = sP.kV * infCell - ...
    phage * sP.muMaxPred2 * senPrey / ...
    ((sP.Knv + senPrey + resPrey) * sP.yieldIPerV);

dBdelloplast2 = phage * sP.muMaxPred2 * senPrey / ...
    (sP.Knv + senPrey+ resPrey) - ...
    sP.kV * infCell / sP.yieldVPerI;

%write results
dy = [dSub; dSenPrey; dResPrey; dPred1; dBdelloplast1; dPred2; ...
    dBdelloplast2];

end
