function plotGaps(dataGaps, saveFile, fileBase)

% Plots the distances between simulated and observed data
% 
% dataGaps is a vectors of distances. 
%
% function plotGaps(dataGaps, saveFile, fileBase)
%
% dataGaps      - The data to plot
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  05/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

fig = figure;
plot(dataGaps, '.')
axis square;

ax = gca; % current axes
ax.FontSize = 14;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
xlim([0 size(dataGaps, 1)]);
curLims = ylim;
ylim([0 curLims(2)]);
title({'Plot of distances of simulations from observed data', ''}, ...
    'FontSize', 14);

xlabel('Parameter sets tried', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Distance from observed data', 'FontSize', 14, ...
    'FontWeight', 'bold');

if saveFile
    
    try
        % Save the figure 
        fig.PaperUnits = 'centimeter';
        fig.PaperPosition = [2 2 17 17];
        fig.PaperPositionMode = 'manual';
        figFileName = [fileBase ' distances'];
        figSaveName = [figFileName '.pdf'];
        print(fig, figSaveName, '-dpdf', '-r600')
        figSaveName = [figFileName '.fig'];
        savefig(fig, figSaveName)
        figSaveName = [figFileName '.png'];
        print(fig, figSaveName, '-dpng', '-r600')
    catch
    end
end


end