    function plotMultiHistograms(abcValues, paramNames, ...
    evenBins, saveFile, fileBase)

% Plot a histogram for each of the parameters passed in.
% 
% The abcData is a abcValues with each column containing the trace for a
% different parameter. Plot a histogram of these each on a seperate graph. 
%
% function plotMultiHistograms(abcValues, paramNames, ...
%    evenBins, saveFile, fileBase)
%
% abcData       - The data to plot
% paramNames    - Plot titles
% evenBins		- If true all plots have the same number (10) of bins
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  06/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

for i = 1:size(abcValues, 2)
    plotTitle = paramNames(i);
    fig = figure;
    hold on
    
    for j = 1:size(abvValues, 3)
        histValues = abcValues(:, :, j);
    
        if evenBins
            histogram(histValues(:, i), 10, 'Normalization', 'probability')
        else
            histogram(histValues(:, i), 'Normalization', 'probability')
        end
    
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