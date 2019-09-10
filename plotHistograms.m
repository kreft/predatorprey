function plotHistograms(abcData, minVals, maxVals, paramNames, ...
    evenBins, saveFile, fileBase)

% Plot a histogram for each of the parameters passed in.
% 
% The abcData is a matrix with each column containing the trace for a
% different parameter. Plot a histogram of these each on a seperate graph. 
%
% function plotAbcData(abcData, saveFile, fileBase)
%
% abcData       - The data to plot
% minVals       - min X value for the plot
% minVals       - min X value for the plot
% paramNames    - Plot titles
% evenBins      - Should bin size be forced?
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  29/08/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.02       J K Summers  26/10/17  Added min and max values
%

for i = 1:size(abcData, 2)
    plotTitle = paramNames(i);
    fig = figure;
    
    if evenBins
        histogram(abcData(:, i), 12, 'FaceColor', [0.75 0.75 0.75], ...
            'LineWidth', 2)
    else
        histogram(abcData(:, i), 'FaceColor', [0.75 0.75 0.75], ...
            'LineWidth', 2)
    end

%     xlim([minVals(i), maxVals(i)]);
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
        figFileName = [fileBase char(plotTitle)];
        figSaveName = [figFileName '.pdf'];
        print(fig, figSaveName, '-dpdf', '-r600')
        figSaveName = [figFileName '.fig'];
        savefig(fig, figSaveName)
        figSaveName = [figFileName '.png'];
        print(fig, figSaveName, '-dpng', '-r600')
    end

end

end