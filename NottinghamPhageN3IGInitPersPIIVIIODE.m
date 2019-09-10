function dy = NottinghamPhageN3IGInitPersPIIVIIODE(t, y, sP)

% ODEs for a prey and two predators system
%
% Equations represent a batch system with an abiotic resource, prey species
% demonstrating monod kinetics, some of which show resistance to predation
% and two predators both exhibiting a Holling type II functional response 
% and each with a seperate bdelloplast / infected cell stage.
%
% function dy = NottinghamPhageN3IGInitPersPIIVIIODE(t, y, sP)
%
% dy    - the rate equations
%
% t     - time series
% y     - initial species values
% sP    - simulation parameters

% Version    Author       Date     Affiliation
% 1.00       J K Summers  12/05/17 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Initial numbers of individuals in species being modeled
sub = y(1);             % substrate value               in fg/ml
senPrey = y(2);         % Sensitive cells               in cells / ml
bdResPrey = y(3);       % Bdellovibrio resistant cells  in cells / ml
phageResPrey = y(4);    % phage resistant cells         in cells / ml
bd = y(5);              % Bdellovibrio cells            in cells / ml
bdplast = y(6);         % Bdelloplasts                  in cells / ml
phage = y(7);           % Phage virions                 in virions / ml
infCell = y(8);         % Infected cells                in cells / ml

% Rates for processes
dSub = -(senPrey + bdResPrey + phageResPrey) * sP.muMaxPrey * sub / ...
    ((sP.Ksn + sub) * sP.yieldNPerS) + ...
    sP.phageNutrients * sP.muMaxBdplast2 * infCell + ...
    sP.bdNutrients * sP.muMaxBdplast1 * bdplast;

% Bdellovibrio resistance is phenotypic so resistant bacteria divide to
% give sensitive bacteria
dSenPrey = (senPrey + bdResPrey) * sP.muMaxPrey * sub / ...
    (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * senPrey / ...
    ((sP.KsPd1 + senPrey + bdResPrey + phageResPrey) * sP.preyYield1) - ...
    phage * sP.muMaxPred2 * senPrey / ...
    ((sP.KsPd2 + senPrey + bdResPrey + phageResPrey) * sP.preyYield2);

dBdResPrey = - phage * sP.muMaxPred2 * bdResPrey / ...
    ((sP.KsPd2 + senPrey + bdResPrey + phageResPrey) * sP.preyYield2);

dPhageResPrey = phageResPrey * sP.muMaxPrey * sub / (sP.Ksn + sub) - ...
    bd * sP.muMaxPred1 * phageResPrey / ...
    ((sP.KsPd1 + senPrey + bdResPrey + phageResPrey) * sP.preyYield1);

dPred1 = sP.muMaxBdplast1 * bdplast - ...
    bd * sP.muMaxPred1 * (senPrey + phageResPrey) / ...
    ((sP.KsPd1 + (senPrey + bdResPrey + phageResPrey)) * sP.predYield1) - ...
    sP.mortality * bd;

dBdelloplast1 = bd * sP.muMaxPred1 * (senPrey + phageResPrey) / ...
    (sP.KsPd1 + (senPrey + bdResPrey + phageResPrey)) - ...
    sP.muMaxBdplast1 * bdplast / sP.bdYield1;

dPred2 = sP.muMaxBdplast2 * infCell - ...
    phage * sP.muMaxPred2 * (senPrey + bdResPrey) / ...
    ((sP.KsPd2 + senPrey + bdResPrey + phageResPrey) * sP.predYield2);

dBdelloplast2 = phage * sP.muMaxPred2 * (senPrey + bdResPrey) / ...
    (sP.KsPd2 + senPrey + bdResPrey + phageResPrey) - ...
    sP.muMaxBdplast2 * infCell / sP.bdYield2;

%write results
dy = [dSub; dSenPrey; dBdResPrey; dPhageResPrey; dPred1; ...
    dBdelloplast1; dPred2; dBdelloplast2];

end
