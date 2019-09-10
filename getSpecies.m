function [speciesData, timeOut] = ...
    getSpecies(simParams, fixedVals, dataVals, simTimes, simMode, ...
    subSpecies)

% Generate species data based on parameters.
% 
% function [speciesData, timeOut] = ...
%    getSpecies(simParams, fixedVals, dataVals, simTimes, simMode, ...
%    subSpecies)
%
% speciesData   - species values for parameters passed in
% timeOut       - Did the simulation fail to produce values
%
% simParams     - The parameters for the simulation
% fixedVals     - Some values which are not changed
% dataVals		- Initial species values
% simTimes      - Time points for which data should be plotted.
% simMode       - Which ODE equations should be used
% subSpecies    - Should species be aggregated or sub species returned

% Version    Author       Date      Affiliation
% 1.00       J K Summers  10/10/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.01		 J K Summers  24/11/17  Added mode 12 for interconversion 
%                                   between sensitive and persister prey
% 1.02		 J K Summers  24/11/17  Added mode 13 for interconversion 
%                                   between sensitive and persister prey
%                                   rate based on dead prey
% 2			 J K Summers  06/12/17  Restructured to avoid repetition.
%									Added support for modes 22 & 26
%									Alarmone on prey killed by phage only
%									(22) & by Bdellovibrio only (26)
% 2.01		 J K Summers  06/12/17  Added support for modes 14 & 15
% 2.02       J K Summers  11/12/17  Added support for modes 16 & 24
% 2.03		 J K Summers  12/12/17  Added support for modes 17 & 18
% 2.04       J K Summers  13/12/17  Added support for modes 19, 20 & 21
% 2.05       J K Summers  14/12/17  Added support for mode 23
% 2.06		 J K Summers  14/12/17  Added support for mode 25
% 2.07       J K Summers  15/12/17  Added support for mode 27
% 2.08       J K Summers  16/08/18  Added support for modes 29 & 30
%                                   Call getODESpecies to invoke ODE calls
% 2.09       J K Summers  03/09/18  Added support for modes 31 & 32
% 2.10       J K Summers  17/09/18  Added support for mode 33
% 3.0		 J K Summers  05/10/18  Rewrote for maintainability & to allow 
%                                   multiple initial values
% 3.1        J K Summers  02/12/18  Added subSpecies

[initVals, paramValsODE] = NottinghamPhageSetup(simParams, ...
    fixedVals, dataVals, simMode);

if subSpecies
    speciesData = zeros(size(simTimes, 1), 4, 8);
else
    speciesData = zeros(size(simTimes, 1), 4, 4);
end

if simMode == 1
    initSpecies(1:5) = initVals(1:5); 	% Substrate & all prey species
    initSpecies(6:9) = zeros(4, 1); 	% predators
elseif (simMode == 2 || simMode == 3 || simMode == 10)
    initSpecies(1:3) = initVals(1:3); 	% substrate & prey species
    initSpecies(4:7) = zeros(4, 1); 	% predators
elseif simMode == 9
    initSpecies(1:2) = initVals(1:2); 	% Substrate & prey
    initSpecies(3:6) = zeros(4, 1); 	% Predators
else
	initSpecies(1:4) = initVals(1:4);	% Substrate & prey
	initSpecies(5:8) = zeros(4, 1);     % Predators

    if (simMode == 13 || simMode == 16 || simMode == 17 || ...
		simMode == 18 || simMode == 19 || simMode == 20 || ...
        simMode == 21 || simMode == 22 || simMode == 23 || ...
        simMode == 24 || simMode == 26 || simMode == 27 || ...
        simMode == 28 || simMode == 29 || simMode == 30 || ...
    	simMode == 31 || simMode == 32 || simMode == 33)
    	initSpecies(9) = zeros(1, 1); 	% Alarmone
    end
    
end

[speciesVals, timeOut] = ...
    getODESpecies(initSpecies, paramValsODE, simTimes, simMode);

if ~timeOut
	% Substrate
    speciesData(:, 1, 1) = speciesVals(:, 1);

	% Prey species
    if simMode == 1
        % Prey species
        speciesData(:, 1, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4) + speciesVals(:, 5);
	elseif (simMode == 2 || simMode == 3 || simMode == 10)
        % Total prey bacteria
        speciesData(:, 1, 2) = speciesVals(:, 2) + speciesVals(:, 3);
    elseif simMode == 9
        speciesData(:, 1, 2) = speciesVals(:, 2);
    elseif subSpecies
        speciesData(:, 1, 2) = speciesVals(:, 2);
        speciesData(:, 1, 3) = speciesVals(:, 3);
        speciesData(:, 1, 4) = speciesVals(:, 4);
    else
        speciesData(:, 1, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
        speciesVals(:, 4);
    end
    
    if simMode == 1
    	initSpecies(1:6) = initVals(1:6); 	% Substrate, prey & Bdellovibrio
   	 	initSpecies(7:9) = zeros(3, 1); 	% Bdelloplast, phage, infected cell
	elseif (simMode == 2 || simMode == 3 || simMode == 10)
   	 	initSpecies(1) = initVals(1); 		% Substrate
   	 	initSpecies(2:3) = initVals(4:5); 	% Prey
   	 	initSpecies(4) = initVals(10); 		% Substrate, prey & Bdellovibrio
    	initSpecies(5:7) = zeros(3, 1); 	% Bdelloplast, phage, infected cell
	elseif simMode == 9
	    initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2) = initVals(3); 		% Prey
	    initSpecies(3) = initVals(6); 		% Bdellovibrio
 	   	initSpecies(4:6) = zeros(3, 1); 	% Bdelloplast, phage, infected cell
    else
	    initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2:4) = initVals(5:7);  	% Prey
	    initSpecies(5) = initVals(14);		% Bdellovibrio
	    initSpecies(6:8) = zeros(3, 1); 	% Bdelloplast, phage, infected cell
	    
        if (simMode == 13 || simMode == 16 || simMode == 17 || ...
        	simMode == 18 || simMode == 19 || simMode == 20 || ...
        	simMode == 21 || simMode == 22 || simMode == 23 || ...
        	simMode == 24 || simMode == 26 || simMode == 27 || ...
        	simMode == 28 || simMode == 29 || simMode == 30 || ...
        	simMode == 31 || simMode == 32 || simMode == 33)
        	initSpecies(9) = zeros(1, 1);	% alarmone
        end
        
    end

    [speciesVals, timeOut] = ...
        getODESpecies(initSpecies, paramValsODE, simTimes, simMode);
end

if ~timeOut
	% Substrate
    speciesData(:, 2, 1) = speciesVals(:, 1); 

    if simMode == 1
        % Prey
        speciesData(:, 2, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4) + speciesVals(:, 5);
        % Bdellovibrio & Bdelloplasts
        speciesData(:, 2, 3) = speciesVals(:, 6) + speciesVals(:, 7);
	elseif (simMode == 2 || simMode == 3 || simMode == 10)
        % Prey
        speciesData(:, 2, 2) = speciesVals(:, 2) + speciesVals(:, 3);
        % Bdellovibrio & Bdelloplasts
        speciesData(:, 2, 3) = speciesVals(:, 4) + speciesVals(:, 5);
    elseif simMode == 9
        % Prey
        speciesData(:, 2, 2) = speciesVals(:, 2);
        % Bdellovibrio & Bdelloplasts
        speciesData(:, 2, 3) = speciesVals(:, 3) + speciesVals(:, 4);
    elseif subSpecies
        % Prey
        speciesData(:, 2, 2) = speciesVals(:, 2); 
        speciesData(:, 2, 3) = speciesVals(:, 3);
        speciesData(:, 2, 4) = speciesVals(:, 4);
        % Bdellovibrio & Bdelloplasts
        speciesData(:, 2, 5) = speciesVals(:, 5);
        speciesData(:, 2, 6) = speciesVals(:, 6);
    else
        % Prey
        speciesData(:, 2, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4);
        % Bdellovibrio & Bdelloplasts
        speciesData(:, 2, 3) = speciesVals(:, 5) + speciesVals(:, 6);
    end    
    
    if simMode == 1
    	initSpecies(1:5) = initVals(1:5);
    	initSpecies(6) = 0;
    	initSpecies(7) = initVals(7);
    	initSpecies(8:9) = zeros(2, 1);
	elseif (simMode == 2 || simMode == 3 || simMode == 10)
	    initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2:3) = initVals(6:7); 	% Prey
    	initSpecies(4:5) = zeros(2, 1);   	% Bdellovibrio & Bdelloplast
    	initSpecies(6) = initVals(13); 		% Bacteriophage
	    initSpecies(7) = zeros(1, 1); 		% Infected cells
    elseif simMode == 9
    	initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2) = initVals(4); 		% Prey
    	initSpecies(3:4) = zeros(2, 1);   	% Bdellovibrio & Bdelloplast
    	initSpecies(5) = initVals(9);		% Bacteriophage
    	initSpecies(6) = zeros(1, 1);		% Infected cells
    else 
	    initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2:4) = initVals(8:10); 	% Prey
	    initSpecies(5:6) = zeros(2, 1);   	% Bdellovibrio & Bdelloplast
	    initSpecies(7) = initVals(17); 		% Bacteriophage
	    initSpecies(8) = zeros(1, 1);     	% Infected cells 
	    
	    if (simMode == 13 || simMode == 16 || simMode == 17 || ...
         	simMode == 18 || simMode == 19 || simMode == 20 || ...
        	simMode == 21 || simMode == 22 || simMode == 23 || ...
        	simMode == 24 || simMode == 26 || simMode == 27 || ...
       	 	simMode == 28 || simMode == 29 || simMode == 30 || ...
        	simMode == 31 || simMode == 32 || simMode == 33)
        	initSpecies(9) = zeros(1, 1);		% Dead prey
    	end

    end

    [speciesVals, timeOut] = ...
        getODESpecies(initSpecies, paramValsODE, simTimes, simMode);
end
    
if ~timeOut
	% Substrate
    speciesData(:, 3, 1) = speciesVals(:, 1);

    if simMode == 1
		% Prey bacteria
        speciesData(:, 3, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4) + speciesVals(:, 5);
        % Halophage & infected cells
        speciesData(:, 3, 4) = speciesVals(:, 8) + speciesVals(:, 9);
    elseif (simMode == 2 || simMode == 3 || simMode == 10)
		% Prey bacteria
        speciesData(:, 3, 2) = speciesVals(:, 2) + speciesVals(:, 3);
        % Halophage & infected cells
        speciesData(:, 3, 4) = speciesVals(:, 6) + speciesVals(:, 7);
    elseif simMode == 9
		% Prey bacteria
        speciesData(:, 3, 2) = speciesVals(:, 2);
        % Phage & Infected cells
        speciesData(:, 3, 4) = speciesVals(:, 5) + speciesVals(:, 6);
    elseif subSpecies
		% Prey bacteria
        speciesData(:, 3, 2) = speciesVals(:, 2);
        speciesData(:, 3, 3) = speciesVals(:, 3);
        speciesData(:, 3, 4) = speciesVals(:, 4);
        % Halophage & infected cells
        speciesData(:, 3, 7) = speciesVals(:, 7);
        speciesData(:, 3, 8) = speciesVals(:, 8);
    else
		% Prey bacteria
        speciesData(:, 3, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4);
        % Halophage & infected cells
        speciesData(:, 3, 4) = speciesVals(:, 7) + speciesVals(:, 8);
    end
    
    if (simMode == 2 || simMode == 3 || simMode == 10)
	    initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2:3) = initVals(8:9); 	% Prey
    	initSpecies(4:5) = initVals(11:12); % Bdellovibrio & Bdelloplast
    	initSpecies(6:7) = initVals(14:15); % Bacteriophage & Infected cells
    elseif simMode == 9
    	initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2) = initVals(5); 		% Prey
    	initSpecies(3:4) = initVals(7:8);	% Bdellovibrio & Bdelloplast
    	initSpecies(5:6) = initVals(10:11);	% Bacteriophage & Infected cells
    else
	    initSpecies(1) = initVals(1); 		% Substrate
	    initSpecies(2:4) = initVals(11:13);	% Prey
	    initSpecies(5:6) = initVals(15:16);	% Bdellovibrio & Bdelloplast
	    initSpecies(7:8) = initVals(18:19);	% Bacteriophage
	    
	    if (simMode == 13 || simMode == 16 || simMode == 17 || ...
        	simMode == 18 || simMode == 19 || simMode == 20 || ...
       	 	simMode == 21 || simMode == 22 || simMode == 23 || ...
        	simMode == 24 || simMode == 26 || simMode == 27 || ...
        	simMode == 28 || simMode == 29 || simMode == 30 || ...
        	simMode == 31 || simMode == 32 || simMode == 33)
        	initSpecies(9) = zeros(1, 1);	% Dead prey
    	end

    end
    
    [speciesVals, timeOut] = ...
        getODESpecies(initSpecies, paramValsODE, simTimes, simMode);
end
   
if ~timeOut
	% Substrate
    speciesData(:, 4, 1) = speciesVals(:, 1);

    if simMode == 1
		% Prey cells
        speciesData(:, 4, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4) + speciesVals(:, 5);
        % Bdellovibrio & bdelloplasts
        speciesData(:, 4, 3) = speciesVals(:, 6) + speciesVals(:, 7);
        % Infected cells & phage
        speciesData(:, 4, 4) = speciesVals(:, 8) + speciesVals(:, 9);
    elseif (simMode == 2 || simMode == 3 || simMode == 10)
		% Prey cells
        speciesData(:, 4, 2) = speciesVals(:, 2) + speciesVals(:, 3);
        % Bdellovibrio & bdelloplasts
        speciesData(:, 4, 3) = speciesVals(:, 4) + speciesVals(:, 5);
        % Infected cells & phage
        speciesData(:, 4, 4) = speciesVals(:, 6) + speciesVals(:, 7);
    elseif simMode == 9
        % Prey bacteria
        speciesData(:, 4, 2) = speciesVals(:, 2);
        % Bdellovbirio & Bdelloplasts
        speciesData(:, 4, 3) = speciesVals(:, 3) + speciesVals(:, 4);
        % Phage & Infected cells
        speciesData(:, 4, 4) = speciesVals(:, 5) + speciesVals(:, 6);  
    elseif subSpecies
        speciesData(:, 4, 2) = speciesVals(:, 2);
        speciesData(:, 4, 3) = speciesVals(:, 3);
        speciesData(:, 4, 4) = speciesVals(:, 4);
        speciesData(:, 4, 5) = speciesVals(:, 5);
        speciesData(:, 4, 6) = speciesVals(:, 6);
        speciesData(:, 4, 7) = speciesVals(:, 7);
        speciesData(:, 4, 8) = speciesVals(:, 8);
    else
        speciesData(:, 4, 2) = speciesVals(:, 2) + speciesVals(:, 3) + ...
            speciesVals(:, 4);
        speciesData(:, 4, 3) = speciesVals(:, 5) + speciesVals(:, 6);
        speciesData(:, 4, 4) = speciesVals(:, 7) + speciesVals(:, 8);
    end
       
end
    
speciesData(speciesData < 1) = 1;

end