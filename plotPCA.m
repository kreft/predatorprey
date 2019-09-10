function plotPCA(coEffs, scores, labels, showDist, distances, ...
    allowedDist, savePlot, fileName)

% Plot the first 2 principal components of the paramets
%
% function plotPCA(coEffs, scores, labels, showDist, distances, ...
%    allowedDist, savePlot, fileName)
%
% coEffs        - Contribution of regular params to first 2 principal
% components
% scores        - The parameters in 2 component space
% labels        - Names of original parameters
% showDist      - Should data be split by distance
% distances     - Distance between simulated and obsevered data
% allowedDist   - Reject all parameter sets with a distance greater than
% this
% savePlot      - Should plots be saved?
% fileName      - Base filename for all plots from this simulation

% Version    Author       Date      Affiliation
% 1.00       J K Summers  25/09/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%
figure

if showDist
    fig = biplot(coEffs(:, 1:2), 'Scores', scores(:, 1:2), ...
        'VarLabels', labels, 'ObsLabels', num2str(distances));
    text(scores(:, 1), scores(:, 2), num2str((1:1000)'));
        
    for i = size(coEffs, 1):length(fig)
        userdata = get(fig(i), 'UserData');

        if ~isempty(userdata)

            if distances(userdata) < allowedDist
                set(fig(i), 'Color', 'b', 'Marker', 'x');
            else
                set(fig(i), 'Color', 'r', 'Marker', 'x');
            end

        end

    end

else
    biplot(coEffs(:, 1:2), 'Scores', scores(:, 1:2), ...
        'VarLabels', labels);
end    

axis square;

ax = gca; % current axes
ax.FontSize = 10;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
title('Parameters in two principal components space', 'FontSize', 14);

xlabel('First principal component', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Second principal component', 'FontSize', 14, 'FontWeight', 'bold');

if savePlot
    % Save the figure 
    fig = gcf;
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figSaveName = [fileName '.pdf'];
    print(fig, figSaveName, '-dpdf', '-r600')
    figSaveName = [fileName '.fig'];
    savefig(fig, figSaveName)
    figSaveName = [fileName '.png'];
    print(fig, figSaveName, '-dpng', '-r600')
end

end