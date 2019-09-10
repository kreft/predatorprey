function NottinghamPhageBoxPlotParams(params, paramNames, paramPriors, ...
    savePlot, fileBase) 

% Creates box plots of the paramater data supplied
%
% function NottinghamPhageBoxPlotParams(params, paramNames, paramPriors, ...
%    savePlot, fileBase) 
%
% params        - the parameters that are to be plotted
% paramNames    - names of the parameters
% paramPriors   - Priors for the parameters
% savePlot      - should the plots be saved
% fileBase      - the base for the filename to save the plot as

% Version    Author       Date     Affiliation
% 1.00       J K Summers  2/1/18   Kreft Lab - School of Biosciences -
%                                  University of Birmingham
% 1.01       J K Summers  4/1/18   Also plot priors in lane 1.

for i = 1:size(params, 2)
    numGens = size(params, 3);
    plotParams(:, 2:numGens + 1) = params(:, i, :);
    halfPoint = ceil(size(params, 1) / 2);
    plotParams(1:halfPoint, 1) = log10(paramPriors(i, 1));
    plotParams((halfPoint + 1):size(params, 1), 1) = ...
        log10(paramPriors(i, 2));
    fig = figure;
    handler = boxplot(plotParams);
%    axis square;

    set(handler, 'linewidth', 2);
    ax = gca; % current axes
    ax.FontSize = 22;
    ax.LineWidth = 1.2;
    ax.TickDir = 'out';
    ax.TickLength = [0.02 0.02];
    ax.YLabel.String = 'Log parameter value';
    title({paramNames{i}, ''}, 'FontSize', 22);
        
    if savePlot
        % Save the figure 
        fig.PaperUnits = 'centimeter';
        fig.PaperPosition = [2 2 17 17];
        fig.PaperPositionMode = 'manual';
        figFileName =[fileBase paramNames{i} '.pdf'];
        print(fig, figFileName, '-dpdf', '-r600')
        figFileName =[fileBase paramNames{i} '.fig'];
        savefig(fig, figFileName)
        figFileName =[fileBase paramNames{i} '.png'];
        print(fig, figFileName, '-dpng', '-r600')
    end

end

end


