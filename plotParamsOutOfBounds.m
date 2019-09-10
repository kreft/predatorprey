function plotParamsOutOfBounds(invalidParams, setTries, saveFile, fileBase)

% Plot the percentage each parameter went out of bounds.
% 
% The invalidParams is a vectors of how many times each parameter went out
% of bounds.
%
% function plotParamsOutOfBounds(invalidParams, setTries, saveFile, fileBase)
%
% invalidParams - The data to plot
% setTries      - Number of parameter sets tried
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  01/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

invalidParams = invalidParams * 100 / setTries;

fig = figure;
plot(invalidParams, 'o')
axis square;

ax = gca; % current axes
ax.FontSize = 14;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
title({'Plot of parameter out of bounds percentages', ''}, 'FontSize', 14);

xlabel('Parameter', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Percentage out of bounds', 'FontSize', 14, 'FontWeight', 'bold');

if saveFile
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName = [fileBase ' out of bounds'];
    figSaveName = [figFileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [figFileName '.fig'];
    savefig(fig, figSaveName)
    figSaveName = [figFileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end