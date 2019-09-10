function NottinghamPhageDotPlotParams(params, paramNames, savePlot, ...
    fileBase) 

% Creates dot plots of the paramater data supplied
%
% function NottinghamPhageDotPlotParams(params, paramNames, savePlot, ...
%     fileBase) 
%
% params        - the parameters that are to be plotted
% paramNames    - names of the parameters
% savePlot      - should the plots be saved
% fileBase      - the base for the filename to save the plot as

% Version    Author       Date     Affiliation
% 1.00       J K Summers  3/1/18   Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

for i = 1:size(params, 2)
    fig = figure;
    
    for j = 1:size(params, 3)
        xVals = repmat(j, size(params, 1));
        yVals = params(:, i, j);
        hold on
        plot(xVals, yVals, 'b.');
    end
    
%    axis square;

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


