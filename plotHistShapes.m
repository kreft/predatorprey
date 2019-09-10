function plotHistShapes(shapeParams, shapeType, protocolFile, saveFile)

% Plot how the shape of a histogram changes with tolerance.
% 
% function plotHistShapes(shapeParams, shapeType, paramNames, saveFile)
%
% shapeParams   - The data to plot
% shapeType     - Either width of SD
% protocolFile  - File with configuration details
% saveFile      - Should the plots be saved

% Version    Author       Date      Affiliation
% 1.00       J K Summers  06/11/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

params = readtable(protocolFile);
 
numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);

fileBase = [char(params.plotName(1)) char(params.trueTitles(1)) ' '];

for i = 1:numParams
    fig = figure;
    plot(shapeParams(:, i), 'x')
    axis square;

    ax = gca; % current axes
    ax.FontSize = 14;
    ax.LineWidth = 1.2;
    ax.TickDir = 'out';
    ax.TickLength = [0.02 0.02];
    curLims = ylim;
    ylim([0 curLims(2)]);

    title({['Plot of ', shapeType, ' of accepted parameters for '], ...
        char(paramNames(i)), ' '}, 'FontSize', 14);

    ylabel(shapeType, 'FontSize', 14, 'FontWeight', 'bold');

    if saveFile
        % Save the figure 
        fig.PaperUnits = 'centimeter';
        fig.PaperPosition = [2 2 17 17];
        fig.PaperPositionMode = 'manual';
        figFileName = ...
            [fileBase ' ' char(paramNames(i)) ' parameter hist shape ' ...
            shapeType];
        figSaveName = [figFileName '.pdf'];
        print(fig, figSaveName, '-dpdf', '-r600')
        figSaveName = [figFileName '.fig'];
        savefig(fig, figSaveName)
        figSaveName = [figFileName '.png'];
        print(fig, figSaveName, '-dpng', '-r600')
    end
    
end

end