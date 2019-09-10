function plotDoubleHistograms(abcValuesSing, abcValuesBoth, paramNames, ...
    evenBins, saveFile, fileBase)

% Plot a double histogram for each of the parameters passed in.
% 
% abcValuesSing and abcValuesBoth are matrices with each column containing 
% the trace for a different parameter. Plot a histogram of each parameter 
% on a seperate graph. 
%
% function plotDoubleHistograms(abcValuesSing, abcValuesBoth, paramNames, ...
%     evenBins, saveFile, fileBase)
%
% abcValuesSing - The parameters for fitting to single predator data
% abcValuesBoth - The parameters for fitting to dual predator data
% paramNames    - Plot titles
% evenBins      - Should bin sizes be fixed?
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  06/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

for i = 1:size(abcValuesSing, 2)
    plotTitle = paramNames(i);
    fig = figure;
    
    if evenBins
        histogram(abcValuesSing(:, i), 10, 'Normalization', 'probability')
    else
        histogram(abcValuesSing(:, i), 'Normalization', 'probability')
    end
    
    hold on
    
    if evenBins
        histogram(abcValuesBoth(:, i), 10, 'Normalization', 'probability')
    else
        histogram(abcValuesBoth(:, i), 'Normalization', 'probability')
    end
    
    axis square;

    ax = gca; % current axes
    ax.FontSize = 14;
    ax.LineWidth = 1.2;
    ax.TickDir = 'out';
    ax.TickLength = [0.02 0.02];
    title({['Histogram for ', char(plotTitle)], ''}, 'FontSize', 14);

    xlabel('Log of parameter value', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Frequency', 'FontSize', 14, 'FontWeight', 'bold');

    if saveFile
        % Save the figure 
        fig.PaperUnits = 'centimeter';
        fig.PaperPosition = [2 2 17 17];
        fig.PaperPositionMode = 'manual';
        figFileName = [fileBase ' double ' char(plotTitle)];
        figSaveName = [figFileName '.pdf'];
        print(fig, figSaveName, '-dpdf', '-r600')
        figSaveName = [figFileName '.fig'];
        savefig(fig, figSaveName)
        figSaveName = [figFileName '.png'];
        print(fig, figSaveName, '-dpng', '-r600')
    end

end

end