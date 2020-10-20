function plotSensFig(simTimes, baseVals, upVals, downVals, colours, ...
    plotTitle, savePlot, fileName)

% Plot the data passed in
% 
% function plotSensFig(simTimes, baseVals, upVals, downVals, colours, ...
%    plotTitle, savePlot, fileName)
%
% simTimes      - Time points for which data should be plotted.
% baseVals      - Base data to plot
% upVals        - Up sensitivity data to plot
% downVals      - Down sensitivity data to plot
% colours       - Colours for the data
% plotTitle     - Title for the plot
% savePlot      - Should plots be saved?
% fileName      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  05/12/19  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

fig = figure;

for iSpecies = 1:size(baseVals, 3)
    plot(simTimes, baseVals(:, 1, iSpecies), colours(iSpecies));
    hold on
    plot(simTimes, upVals(:, :, 1, iSpecies), [colours(iSpecies) '--']);
    plot(simTimes, downVals(:, :, 1, iSpecies), [colours(iSpecies) ':']);
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