function steadyStateFound = SteadyState(t, species, checkWindow, threshold)

% Version    Author       Date      Affiliation
% 1.00       J K Summers  12/06/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

% Checks if the species numbers passed in are at steady state
% Calculates the relative slope for last few values for each of these 
% species and if they are all within a small tolerance of zero they are 
% considered to be at a steady state
%
% function steadyStateFound = SteadyState(t, species, checkWindow, threshold)
%
% steadyStateFound  - Is the system considered to have reached  a steady
% state
%
% t                 - the time points for which we have species values
% species           - species values
% checkWindow       - over how many data points should we analyse the data
% threshold         - How close to zero must any change over time be

% Version    Author       Date     Affiliation
% 1.00       J K Summers  12/05/16 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

% Calculate the slope over the last checkWindow time periods
% First find out how long a period this covers
lastPoint = length(t);

dt = t(lastPoint) - t(lastPoint - checkWindow);

% Now find out how much each species changes over that period, relative to
% their final value
steadyStateFound = true;
i = 1;

while (i <= size(species, 2) && steadyStateFound)
    
    if isnan(max(species(lastPoint - checkWindow:lastPoint, i)))
        steadyStateFound = false;
    else
    
        dSpecies = (max(species(lastPoint - checkWindow:lastPoint, i)) - ...
            min(species(lastPoint - checkWindow:lastPoint, i))) ...
            / (species(lastPoint, i))^0.5;
        dSpeciesDt = dSpecies / dt;

        if (dSpeciesDt > threshold) % 5e-6    
            steadyStateFound = false;
        end
        
    end
    
    i = i + 1;
end
    
end
