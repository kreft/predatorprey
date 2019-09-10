function plotConvergeHistograms(abcValues, protocolFile, evenBins, ...
    saveFile)

% Plot a histogram for each of the parameters passed in.
% 
% The abcValues is a vector of structures with the first dimension 
% representing the scenario, the 2nd dimension is the parameter and the
% third is the value
%
% function plotConvergeHistograms(abcValues, paramNames, evenBins, ...
%     saveFile)
%
% abcValues     - The data to plot
% protocolFile  - File with configuration details
% evenBins      - Should bin size be enforced
% saveFile      - Should the plots be saved

% Version    Author       Date      Affiliation
% 1.00       J K Summers  30/10/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

params = readtable(protocolFile);
 
numParams = params.numParams(1);
   
% initial values
paramNames = params.paramNames(1: numParams);

fileBase = [char(params.plotName(1)) char(params.trueTitles(1)) ' '];
 
minPrior = log10(params.minPrior);
maxPrior = log10(params.maxPrior);
   
for j = 1:numParams
    plotTitle = paramNames(j);
    fig = figure;
%     hold on
    
    for k = 1:size(abcValues, 2)
        paramData = abcValues(k).paramData;

        if size(paramData, 1) > 0
            
            if evenBins
                histogram(log10(paramData(:, j)), 10, ...
                    'Normalization', 'probability')
            else
                histogram(log10(paramData(:, j)), ...
                    'Normalization', 'probability')
            end
            
            axis square;

            ax = gca; % current axes
            ax.FontSize = 14;
            ax.LineWidth = 1.2;
            ax.TickDir = 'out';
            ax.TickLength = [0.02 0.02];
            xlim([minPrior(j) maxPrior(j)]);
            title({['Histogram for ', char(plotTitle), ' ' , j], ''}, ...
                'FontSize', 14);

            xlabel('Log of parameter value', 'FontSize', 14, ...
                'FontWeight', 'bold');
            ylabel('Frequency', 'FontSize', 14, 'FontWeight', 'bold');

            if saveFile
                % Save the figure 
                fig.PaperUnits = 'centimeter';
                fig.PaperPosition = [2 2 17 17];
                fig.PaperPositionMode = 'manual';
                figFileName = ...
                    [fileBase ' double ' char(plotTitle) ' ' num2str(k)];
                figSaveName = [figFileName '.pdf'];
                print(fig, figSaveName, '-dpdf', '-r600')
                figSaveName = [figFileName '.fig'];
                savefig(fig, figSaveName)
                figSaveName = [figFileName '.png'];
                print(fig, figSaveName, '-dpng', '-r600')
            end

        end
    
    end
    
end

end