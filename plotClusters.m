function plotClusters(distGaps, clusterNos, numClusters, savePlot, fileName)

% Create the distances of parameters coloured by cluster
%
% function plotClusters(distGaps, numClusters)
%
% distGaps      - The distances between simulated 2 predator data and
% observed data
% clusterNo     - Which cluster is each distance in?
% numCluster    - The number of clusters to plot
% saveFile      - Should plots be saved?
% fileBase      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  24/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

fig = figure;

for i = 1:numClusters
    plot(distGaps(clusterNos == i), '.');
    hold on
end
    
axis square;

ax = gca; % current axes
ax.FontSize = 10;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
title('Distances between real and simulated data', 'FontSize', 14);

xlabel('Simulation', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Distance', 'FontSize', 14, 'FontWeight', 'bold');

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName ' ' numClusters ' clusters.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName)
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end