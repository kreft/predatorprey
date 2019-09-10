function NottinghamPhagePCAParams(params, labelPoints, savePlot, fileBase) 

% Creates a PCA plot from a set of parameters
%
% function NottinghamPhagePCAParams(params, labelPoints, savePlot, fileBase) 
%
% params        - the parameters that are to be analysed and plotted
% labelPoints   - Should labels be added for each point
% savePlot      - should the plot be saved
% fileBase      - the base for the filename to save the plot as

% Version    Author       Date     Affiliation
% 1.00       J K Summers  5/1/18   Kreft Lab - School of Biosciences -

[paramCoeffs, scores, latents] = pca(params);
contributions = cumsum(latents) ./ sum(latents) * 100;

fig  = figure;
biplot(paramCoeffs(:, 1:2), 'Scores', scores(:, 1:2))

if labelPoints
    [p, d] = size(paramCoeffs);
    
    obslabs = num2str((1:size(params, 1))');
    [~, maxind] = max(abs(paramCoeffs), [], 1);
    colsign = sign(paramCoeffs(maxind + (0:p:(d - 1) * p)));
    score = (scores ./ max(abs(scores(:)))) .* repmat(colsign, 1000, 1);

    text(score(:, 1), score(:, 2), obslabs);
end

axis square;

ax = gca; % current axes
ax.FontSize = 22;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
title('PCA plot of parameters', 'FontSize', 22);
legend(num2str(contributions));

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileBase ' PCA pick plot.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileBase ' PCA pick plot.fig'];
    savefig(fig, figFileName)
    figFileName =[fileBase ' PCA pick plot.png'];
    print(fig, figFileName, '-dpng', '-r600')
end

end


