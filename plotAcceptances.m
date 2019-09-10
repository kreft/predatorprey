function plotAcceptances(accepts, saveFile, fileBase)

% Plot a trace for how many parameter sets are accepted.
% 
% The accepts is a vectors of whether each set was accepted. 
%
% function plotAcceptances(accepts, saveFile, fileBase)
%
% accepts       - The data to plot
% saveFile      - Should the plots be saved
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  01/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%
acceptPers = zeros(size(accepts));

for i = 1:size(accepts, 1)
    acceptPers(i) = sum(accepts(1:i) * 100 / i);
end
    
fig = figure;
plot(acceptPers)
axis square;

ax = gca; % current axes
ax.FontSize = 14;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
title({'Plot of acceptance percentages', ''}, 'FontSize', 14);

xlabel('Parameter sets tried', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Percentage acceptance', 'FontSize', 14, 'FontWeight', 'bold');

if saveFile
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName = [fileBase ' acceptances'];
    figSaveName = [figFileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [figFileName '.fig'];
    savefig(fig, figSaveName)
    figSaveName = [figFileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end