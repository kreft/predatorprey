function [likely, timeOut] = ...
    NottinghamPhageLogLikelihoodGrowth(theta, ...
    fixedVals, simTimes, obsData, dataNoise, simMode, compMode, fitAll)
   
% Calculate the log likelihood of getting the observed data from theta.
% 
% Run the simulation with the candidate theta and determine how likely it
% is that the observed data could have arisen if these where the true
% parameters, given the differences between the observed and simulated data
% and the expected noise of the system.
%
% function likely = NottinghamPhageLogLikelihoodGrowth(theta, ...
%    fixedVals, simTimes, obsData, sigmaData, simMode)
%
% logLikely     - The log likelihood of getting these data if these were
% the true parameters.
%
% theta         - Parameters for the simulation
% fixedVals     - Values that are not varied
% simTimes      - Time points for which we have observed data
% obsData       - The observed data
% sigmaData     - How noisy do we believe the data to be?
% simMode       - Which version of the model to use
% compMode      - How should simulated and observed data be compared?
% fitAll        - Should all data sets be fitted? If False do not fit the 2
%                 predator data set

% Version    Author       Date      Affiliation
% 1.00       J K Summers  02/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

[initVals, thetaODE] = NottinghamPhageSetup(theta, fixedVals, simMode);

% E. coli only simulation
if simMode == 1
    % full model
    initSpecies(1:5) = initVals(1:5); % Substrate & prey species
    initSpecies(6:9) = zeros(4, 1); % predators

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN3PIIVIIODE, simTimes, ...
        initSpecies, thetaODE);
    
    if ~timeOut
        % Total of all bacterial prey species
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
            predVals(:, 4) + predVals(:, 5);
    end
    
elseif simMode == 2
    % simplified model
    initSpecies(1:3) = initVals(1:3); % Substrate & prey bacteria
    initSpecies(4:7) = zeros(4, 1); % Predators

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN2PreyPropPIVIODE, ...
        simTimes, initSpecies, thetaODE);

    if ~timeOut
        % Total prey species
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3);  
    end
    
elseif simMode == 3
    % mixed model

    % Substrate & prey
    initSpecies(1:3) = initVals(1:3);
    % Predators
    initSpecies(4:7) = zeros(4, 1);

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN2PIIVIIODE, ...
        simTimes, initSpecies, thetaODE);

    if ~timeOut
        % Total prey bacteria
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
    end
    
elseif simMode == 4
    % Simplified model, but with Bdellovibrio phenotypic persistence
    initSpecies(1:4) = initVals(1:4); % Substrate & prey
    initSpecies(5:8) = zeros(4, 1); % Predators

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN3IGPIIVII, ...
        simTimes, initSpecies, thetaODE);

    if ~timeOut
        % Total of all prey bacteria
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + predVals(:, 4);
    end
    
elseif (simMode == 5 || simMode == 7)
    % Simplified model, but with ability to develop Bdellovibrio phenotypic
    % persistence
    initSpecies(1:4) = initVals(1:4); % Substrate & prey
    initSpecies(5:8) = zeros(4, 1);   % Predators

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN3IGPIIVIIODE, ...
        simTimes, initSpecies, thetaODE);

    if ~timeOut
        % Total of all prey bacteria
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + predVals(:, 4);
    end
    
elseif simMode == 6
    % As mode 5, but Bdellovibrio now has a Holling type I functional
    % response
    initSpecies(1:4) = initVals(1:4); % Substrate & prey
    initSpecies(5:8) = zeros(4, 1);   % Predators

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN3PreyPropIGPIVIODE, ...
        simTimes, initSpecies, thetaODE);

    if ~timeOut
        % Total of all prey bacteria
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + predVals(:, 4);
    end
    
else
    % Simplified model, but with ability to develop Bdellovibrio phenotypic
    % persistence
    initSpecies(1:4) = initVals(1:4); % Substrate & prey
    initSpecies(5:8) = zeros(4, 1);   % Predators

    [~, predVals, timeOut] = ...
        NottinghamPhageSim(@NottinghamPhageN3IGPIIVIODE, ...
        simTimes, initSpecies, thetaODE);

    if ~timeOut
        % Total of all prey bacteria
        compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + predVals(:, 4);
    end
    
end

if ~timeOut
    oData = obsData(:, 1); % Prey bacteria
    % Remove NaNs
    compVals(isnan(oData)) = [];
    compVals(compVals < 1) = 1;
    oData(isnan(oData)) = [];

    likely = compareData(compVals, oData, dataNoise, compMode);
    %(-0.5 / (sigmaData^2)) * sum((compVals - oData).^2);
end

if ~timeOut
   
    % E. coli and Bdellovibrio simulation
    if simMode == 1
        initSpecies(1:6) = initVals(1:6); % Substrate, Prey & Bdellovibrio
        initSpecies(7:9) = zeros(3, 1); %Bdelloplasts, phage, infectedcells

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3PIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            %Total prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4) + predVals(:, 5);
            % Bdellovibrio + bdelloplasts
            compVals(:, 2) = predVals(:, 6) + predVals(:, 7);
        end

    elseif simMode == 2
        initSpecies(1:4) = initVals(1:4); % Substrate, Prey & Bdellovibrio
        initSpecies(5:7) = zeros(3, 1); %Bdelloplasts, phage, infectedcells

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN2PreyPropPIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
            % Bdellovbirio + bdelloplast
            compVals(:, 2) = predVals(:, 4) + predVals(:, 5);
        end

    elseif simMode == 3
        initSpecies(1:4) = initVals(1:4);
        initSpecies(5:7) = zeros(3, 1);

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN2PIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
            compVals(:, 2) = predVals(:, 4) + predVals(:, 5);
        end

    elseif simMode == 4
        initSpecies(1:5) = initVals(1:5); % Substrate, prey & Bdellovibrio
        initSpecies(6:8) = zeros(3, 1); % Bdelloplast, phage, infected cell

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVII, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
        end

    elseif (simMode == 5 || simMode == 7)
        initSpecies(1:5) = initVals(1:5); % Substrate, prey & Bdellovibrio
        initSpecies(6:8) = zeros(3, 1); % Bdelloplast, phage, infected cell

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
        end

    elseif simMode == 6
        initSpecies(1:5) = initVals(1:5); % Substrate, prey & Bdellovibrio
        initSpecies(6:8) = zeros(3, 1); % Bdelloplast, phage, infected cell

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3PreyPropIGPIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
        end

    else
        initSpecies(1:5) = initVals(1:5); % Substrate, prey & Bdellovibrio
        initSpecies(6:8) = zeros(3, 1); % Bdelloplast, phage, infected cell

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
        end

    end
    
end

if ~timeOut
    % Prey bacteria
    sData = compVals(:, 1);
    oData = obsData(:, 2);

    sData(isnan(oData)) = [];
    sData(sData < 1) = 1; 
    oData(isnan(oData)) = [];

    likely = likely + compareData(sData, oData, dataNoise, compMode);

    % Bdellovibrio
    sData = compVals(:, 2);
    oData = obsData(:, 3);

    sData(isnan(oData)) = [];
    sData(sData < 1) = 1; 
    oData(isnan(oData)) = [];
    likely = likely + compareData(sData, oData, dataNoise, compMode);
end

if ~timeOut

    % E. coli and halophage simulation
    if simMode == 1
        initSpecies(1:5) = initVals(1:5);
        initSpecies(6) = 0;
        initSpecies(7) = initVals(7);
        initSpecies(8:9) = zeros(2, 1);

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3PIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4) + predVals(:, 5);
            compVals(:, 2) = predVals(:, 8) + predVals(:, 9);
        end

    elseif simMode == 2
        initSpecies(1:3) = initVals(1:3);
        initSpecies(4) = 0;
        initSpecies(5) = initVals(5);
        initSpecies(6:7) = zeros(2, 1);

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN2PreyPropPIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
            compVals(:, 2) = predVals(:, 6) + predVals(:, 7);
        end

    elseif simMode == 3
        initSpecies(1:3) = initVals(1:3);
        initSpecies(4:5) = zeros(2, 1);
        initSpecies(6:7) = initVals(6:7);

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN2PIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
            compVals(:, 2) = predVals(:, 6) + predVals(:, 7);
        end

    elseif simMode == 4
        initSpecies(1:4) = initVals(1:4); % Substrate & prey
        initSpecies(5:6) = zeros(2, 1); % Bdellovibrio & Bdelloplast
        initSpecies(7:8) = initVals(7:8); % Bacteriophage & Infected cells

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVII, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % All prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Phage + infected cells
            compVals(:, 2) = predVals(:, 7) + predVals(:, 8);
        end

    elseif (simMode == 5 || simMode == 7)
        initSpecies(1:4) = initVals(1:4); % Substrate & prey
        initSpecies(5:6) = zeros(2, 1); % Bdellovibrio & Bdelloplast
        initSpecies(7:8) = initVals(7:8); % Bacteriophage & Infected cells

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % All prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Phage + infected cells
            compVals(:, 2) = predVals(:, 7) + predVals(:, 8);
        end

    elseif simMode == 6
        initSpecies(1:4) = initVals(1:4); % Substrate & prey
        initSpecies(5:6) = zeros(2, 1); % Bdellovibrio & Bdelloplast
        initSpecies(7:8) = initVals(7:8); % Bacteriophage & Infected cells

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3PreyPropIGPIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % All prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Phage + infected cells
            compVals(:, 2) = predVals(:, 7) + predVals(:, 8);
        end

    else
        initSpecies(1:4) = initVals(1:4); % Substrate & prey
        initSpecies(5:6) = zeros(2, 1); % Bdellovibrio & Bdelloplast
        initSpecies(7:8) = initVals(7:8); % Bacteriophage & Infected cells

        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % All prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Phage + infected cells
            compVals(:, 2) = predVals(:, 7) + predVals(:, 8);
        end

    end
    
end

if ~timeOut
    % Prey bacteria
    sData = compVals(:, 1);
    oData = obsData(:, 4);

    sData(isnan(oData)) = [];
    sData(sData < 1) = 1; 
    oData(isnan(oData)) = [];
    likely = likely + compareData(sData, oData, dataNoise, compMode);

    % Bacteriophage & infected cells
    sData = compVals(:, 2);
    oData = obsData(:, 5);

    sData(isnan(oData)) = [];
    sData(sData < 1) = 1; 
    oData(isnan(oData)) = [];
    likely = likely + compareData(sData, oData, dataNoise, compMode);
end

if fitAll && ~timeOut
    
    % E. coli, Bdellovibrio and Halophage simulation
    if simMode == 1;
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3PIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4) + predVals(:, 5);
            compVals(:, 2) = predVals(:, 6) + predVals(:, 7);
            compVals(:, 3) = predVals(:, 8) + predVals(:, 9);
        end
    
    elseif simMode == 2
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN2PreyPropPIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
            compVals(:, 2) = predVals(:, 4) + predVals(:, 5);
            compVals(:, 3) = predVals(:, 6) + predVals(:, 7);
        end
    
    elseif simMode == 3
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN2PIIVIIODE, ...
            simTimes, initSpecies, thetaODE);
        
        if ~timeOut
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3);
            compVals(:, 2) = predVals(:, 4) + predVals(:, 5);
            compVals(:, 3) = predVals(:, 6) + predVals(:, 7);
        end
    
    elseif simMode == 4
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVII, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
            % Phages & infected cells
            compVals(:, 3) = predVals(:, 7) + predVals(:, 8);
        end

    elseif (simMode == 5 || simMode == 7)
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVIIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
            % Phages & infected cells
            compVals(:, 3) = predVals(:, 7) + predVals(:, 8);
        end
    
    elseif simMode == 6
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3PreyPropIGPIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
            % Phages & infected cells
            compVals(:, 3) = predVals(:, 7) + predVals(:, 8);
        end

    else
        [~, predVals, timeOut] = ...
            NottinghamPhageSim(@NottinghamPhageN3IGPIIVIODE, ...
            simTimes, initSpecies, thetaODE);

        if ~timeOut
            % Total of all prey bacteria
            compVals(:, 1) = predVals(:, 2) + predVals(:, 3) + ...
                predVals(:, 4);
            % Bdellovibrio & bdelloplasts
            compVals(:, 2) = predVals(:, 5) + predVals(:, 6);
            % Phages & infected cells
            compVals(:, 3) = predVals(:, 7) + predVals(:, 8);
        end
    
    end

    if ~timeOut
        % Prey bacteria
        sData = compVals(:, 1);
        oData = obsData(:, 6);

        sData(isnan(oData)) = [];
        sData(sData < 1) = 1; 
        oData(isnan(oData)) = [];
        likely = likely + compareData(sData, oData, dataNoise, compMode);

        % Bdellovibrio & Bdelloplasts
        sData = compVals(:, 2);
        oData = obsData(:, 7);

        sData(isnan(oData)) = [];
        sData(sData < 1) = 1; 
        oData(isnan(oData)) = [];
        likely = likely + compareData(sData, oData, dataNoise, compMode);

        % Phages & infected cells
        sData = compVals(:, 3);
        oData = obsData(:, 8);

        sData(isnan(oData)) = [];
        sData(sData < 1) = 1; 
        oData(isnan(oData)) = [];
        likely = likely + compareData(sData, oData, dataNoise, compMode);
    end
    
end

if ~timeOut
    likely = sum(likely);
else
    likely = 0;
end

end