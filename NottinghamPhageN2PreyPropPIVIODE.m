function dy = NottinghamPhageN2PreyPropPIVIODE(t, y, sP)

% ODEs for a prey and two predators system
% Equations represent a batch system with an abiotic resource, single prey
% demonstrating monod kinetics and two predators both exhibiting a Holling
% type II functional response and each with a seperate bdelloplast stage.
% simMode = 2
%
% function dy = NottinghamPhageN2PIVIODE(t, y, sP)
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
phResPrey = y(3);
bd = y(4);          % numbers of predator 1   in cells / ml
bdplast = y(5);     % amount of bdelloplast 1 in cells / ml
phage = y(6);       % numbers of predator 2   in virions / ml
infCell = y(7);     % amount of bdelloplast 2 in cells / ml

% Rates for processes
dSub = -(senPrey + phResPrey) * sP.muMaxPrey * sub / sP.yieldNPerS + ...
    sP.yieldSPerV * sP.kV * infCell;

dSenPrey = senPrey * sP.muMaxPrey * sub - ...
    bd * sP.muMaxPred1 * senPrey / sP.yieldBPerN - ...
    phage * sP.muMaxPred2 * senPrey / sP.yieldIPerN;

dPhResPrey = phResPrey * sP.muMaxPrey * sub - ...
    bd * sP.muMaxPred1 * phResPrey / sP.yieldBPerN;

dPred1 = sP.kP * bdplast - ...
    bd * sP.muMaxPred1 * (senPrey + phResPrey) / sP.yieldBPerP - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * (senPrey + phResPrey) - ...
    sP.kP * bdplast / sP.yieldPPerB;

dPred2 = sP.kV * infCell - ...
    phage * sP.muMaxPred2 * senPrey / sP.yieldIPerV;

dBdelloplast2 = phage * sP.muMaxPred2 * senPrey - ...
    sP.kV * infCell / sP.yieldIPerV;

%write results
dy = [dSub; dSenPrey; dPhResPrey; dPred1; dBdelloplast1; dPred2; ...
    dBdelloplast2];

end
