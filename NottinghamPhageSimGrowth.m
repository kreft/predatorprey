function [tolerable, dataGap, dataGap2, compVals] = ...
    NottinghamPhageSimGrowth(theta, fixedVals, dataVals, simTimes, ...
    obsData, dataNoise, simMode, compMode, fitAll, acceptError)
   
% Calculate the data from theta is within an acceptable error of obsData.
% 
% Run the simulation with the candidate theta and determine if this is
% within an acceptable error of the observed data
%
% function [tolerable, dataGap, dataGap2, compVals] = ...
%     NottinghamPhageSimGrowth(theta, fixedVals, dataVals, simTimes, ...
%     obsData, dataNoise, simMode, compMode, fitAll, acceptError)
%
% tolerable     - True if the data is within the error threshold, false
% otherwise.
% dataGap       - Gap between single predator simulations and data
% dataGap2      - Gap between dual predator simulations and data
% compVals      - The species values produced by the simulation for these
% parameters
%
% theta         - Parameters for the simulation
% fixedVals     - Values that are not varied
% dataVals		- Initial species numbers
% simTimes      - Time points for which we have observed data
% obsData       - The observed data
% dataNoise     - How noisy do we believe the data to be?
% simMode       - Which version of the model to use
% compMode      - How should simulated and observed data be compared?
% fitAll        - Should fit be to sinlge predator data only, or all data
% acceptError   - Distance from observed data that should be tolerated.

% Version    Author       Date      Affiliation
% 1.00       J K Summers  28/08/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.02       J K Summers  27/10/17  Pass back species values
% 1.03		 J K Summers  05/10/18	Pass in initial species nums, seperate 
%                                   from fixed vals

[compVals, timeOut] = getSpecies(theta, fixedVals, dataVals, simTimes, ...
    simMode);
  
if ~timeOut
    dataGap = 0;
    dataPoints = 0;

    % Prey bacteria in prey only scenario
    oData = obsData(:, 1); 
    sData = compVals(:, 1, 2); 
    
    dataPoints = dataPoints + size(oData, 1) - sum(isnan(oData));
    
    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];
 
    dataGap = dataGap + compareData(sData, oData, dataNoise, compMode);
    
    % Prey bacteria in prey & Bdellovibrio scenario
    oData = obsData(:, 2);
    sData = compVals(:, 2, 2);
 
    dataPoints = dataPoints + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    sData(sData < 1) = 1; 
    oData(isnan(oData)) = [];
 
    dataGap = dataGap + compareData(sData, oData, dataNoise, compMode);
 
    % Bdellovibrio in prey & Bdellovibrio scenario
    oData = obsData(:, 3);
    sData = compVals(:, 2, 3);
 
    dataPoints = dataPoints + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];

    dataGap = dataGap + compareData(sData, oData, dataNoise, compMode);

    % Prey bacteria in prey & Halophage scenario
    oData = obsData(:, 4);
    sData = compVals(:, 3, 2);
 
    dataPoints = dataPoints + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];

    dataGap = dataGap + compareData(sData, oData, dataNoise, compMode);
 
    % Bacteriophage & infected cells in prey & Halophage scenario
    oData = obsData(:, 5);
    sData = compVals(:, 3, 4);
 
    dataPoints = dataPoints + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];

    dataGap = dataGap + compareData(sData, oData, dataNoise, compMode);
    
    % Prey bacteria in dual predator scenario
    oData = obsData(:, 6);
    sData = compVals(:, 4, 2);

    dataPoints2 = dataPoints + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];

    dataGap2 = dataGap + ...
        compareData(sData, oData, dataNoise, compMode);

    % Bdellovibrio & Bdelloplasts in dual predator scenario
    oData = obsData(:, 7);
    sData = compVals(:, 4, 3);

    dataPoints2 = dataPoints2 + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];

    dataGap2 = dataGap2 + ...
        compareData(sData, oData, dataNoise, compMode);

    % Phages & infected cells in dual predator scenario
    oData = obsData(:, 8);
    sData = compVals(:, 4, 4);

    dataPoints2 = dataPoints2 + size(oData, 1) - sum(isnan(oData));

    % Remove NaNs
    sData(isnan(oData)) = [];
    oData(isnan(oData)) = [];

    dataGap2 = dataGap2 + ...
        compareData(sData, oData, dataNoise, compMode);
     
    if (compMode == 3) || (compMode == 4)
        dataGap = dataGap / dataPoints;
        dataGap2 = dataGap2 / dataPoints2;

        if dataGap > 100
            largeGap = true;
        end

    end
        
    if fitAll
        
        if timeOut
            tolerable = false;
        elseif dataGap2 <= acceptError
            tolerable = true;
        else
            tolerable = false;
        end
        
    else
        
        if dataGap <= acceptError
            tolerable = true;
        else
            tolerable = false;
        end
        
    end
    
else
    dataGap = NaN;
    dataGap2 = NaN;
    tolerable = false;
end
 
end

