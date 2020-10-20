function NottinghamPhageBoxPlotRuns(runResults, savePlot, fileBase) 

% Creates box plots of the run replication data supplied
%
% function NottinghamPhageBoxPlotRuns(runResults, savePlot, fileBase) 
%
% runResults    - the run results that are to be plotted
% savePlot      - should the plots be saved
% fileBase      - the base for the filename to save the plot as

% Version    Author       Date     Affiliation
% 1.00       J K Summers  08/12/19 Kreft Lab - School of Biosciences -
%                                  University of Birmingham

fig = figure;
handler = boxplot(runResults);
axis square;

set(handler, 'linewidth', 2);
ax = gca; % current axes
ax.FontSize = 22;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
ax.YLabel.String = 'Num successfull parameters sets';
ylim([0 1000])

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


