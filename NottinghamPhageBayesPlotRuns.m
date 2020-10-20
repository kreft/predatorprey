function NottinghamPhageBayesPlotRuns(runResults, savePlot, fileBase) 

% Creates box plots of the bayes factor of run replication data supplied
%
% function NottinghamPhageBayesPlotRuns(runResults, savePlot, fileBase) 
%
% runResults    - the run results that are to be plotted
% savePlot      - should the plots be saved
% fileBase      - the base for the filename to save the plot as

% Version    Author       Date     Affiliation
% 1.00       J K Summers  08/12/19 Kreft Lab - School of Biosciences -
%                                  University of Birmingham

fig = figure;

iCompare = 0;

for iModel = 1:(size(runResults, 2) - 1)
    
    if max(runResults(:, iModel)) > 0
    
        for jModel = (iModel + 1):size(runResults, 2)
            
            if max(runResults(:, jModel)) > 0
                iCompare = iCompare + 1;
                
                for jCompare = 1:size(runResults, 1)
                    modelCompare(jCompare, iCompare) = ...
                        runResults(jCompare, iModel) / ...
                        runResults(jCompare, jModel);
                end
                
            end
            
        end
        
    end
    
end
        
handler = boxplot(modelCompare);
axis square;

set(handler, 'linewidth', 2);
ax = gca; % current axes
ax.FontSize = 22;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
ax.YLabel.String = 'Bayes factors between models';

if savePlot
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileBase '.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileBase '.fig'];
    savefig(fig, figFileName)
    figFileName =[fileBase '.png'];
    print(fig, figFileName, '-dpng', '-r600')
end

end


