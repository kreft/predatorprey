function plotAbcData(abcData, paramNames, saveFile, fileBase)

% Plot the trace for each of the parameters passed in.
% 
% The abcData is a matrix with each column containing the trace for a
% different parameter. Plot these each on a seperate graph. The first
% row contains the parameter name which should be used as a plot title and
% to save the plot if requested.
%
% function plotAbcData(abcData, paramNames, saveFile, fileBase)
%
% abcData       - The data to plot
% paramNames    - Plot titles
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  02/05/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

for i = 1:size(abcData, 2)
    plotTitle = paramNames(i);
    fig = figure;
    plot(abcData(:, i))
    axis square;

    ax = gca; % current axes
    ax.FontSize = 14;
    ax.LineWidth = 1.2;
    ax.TickDir = 'out';
    ax.TickLength = [0.02 0.02];
    title({'Parameter trace for ', char(plotTitle), ''}, 'FontSize', 12);

    xlabel('Chain iteration', 'FontSize', 16, 'FontWeight', 'bold');
    ylabel('Parameter value', 'FontSize', 16, 'FontWeight', 'bold');

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