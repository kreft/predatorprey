function plotSpecies(simTimes, speciesVals, colours, plotTitle, ...
    savePlot, fileName)

% Plot the data passed in
% 
% function plotSpecies(simTimes, speciesVals, colours, plotTitle, ...
%     savePlot, fileName)
%
% simTimes      - Time points for which data should be plotted.
% speciesVals   - The data to plot
% colours       - Colours for the data
% plotTitle     - Title for the plot
% savePlot      - Should plots be saved?
% fileName      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  10/06/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

fig = figure;

for i = 1:size(speciesVals, 3)
    plot(simTimes, speciesVals(:, 1, i), colours(i));
    hold on
end
    
set(gca, 'YScale', 'log');
axis square;

ax = gca; % current axes
ax.FontSize = 10;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
xlim([simTimes(1) simTimes(size(simTimes, 1))])
title(plotTitle, 'FontSize', 14);

xlabel('Time (hours)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Species per ml', 'FontSize', 14, 'FontWeight', 'bold');

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName);
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end