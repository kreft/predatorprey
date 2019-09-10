function BoxPlotSensitivities(sens, params, tit, outliers, rmInf, save, ...
    fileName) 

% Creates a box plot of the sensitivity data supplied
%
% function BoxPlotSensitivities(sens, params, tit, outliers, rmInf, save, ...
%    fileName) 
%
% sens      - the senstivity data to display
% params    - the parameters that were varied to observe sensitivities
% tit       - the title for the plot
% outliers  - should outliers be displayed
% rmInf     - should any infinities be removed (and replaced with the 
% largest non-infinite value)
% save      - should the plot be saved
% fileName  - the filename to save the plot as

% Version    Author       Date     Affiliation
% 1.00       J K Summers  03/08/16 Kreft Lab - School of Biosciences -
%                                  University of Birmingham
% 1.01       J K Summers  25/01/18 Also save files in png and fig format

if rmInf
    
    for i = 1:size(sens, 2)
   
        if max(sens(:, i)) <= 0
            minSens = min(sens(sens(:, i) ~= Inf, i));
            sens(sens(:, i) == Inf, i) = minSens;
        else
            % Remove all values of infinity and replace with the largest 
            % non-infinite value
            maxSens = max(sens(sens(:, i) ~= Inf, i));
            sens(sens(:, i) == Inf, i) = maxSens;
        end
        
    end
    
end

if outliers
    fig = figure;
    handler = boxplot1(sens, params);
    view(90, 90)

    set(handler, 'linewidth', 2);
    ax = gca; % current axes
    ax.FontSize = 12;
    ax.LineWidth = 1.2;
    ax.TickDir = 'out';
    ax.TickLength = [0.02 0.02];
    ax.YLabel.String = 'Percentage Sensitivity';
    title({tit, ''}, 'FontSize', 16);
    
    if save
        % Save the figure 
        fig.PaperUnits = 'centimeter';
        fig.PaperPosition = [2 2 17 17];
        fig.PaperPositionMode = 'manual';
        figFileName =[fileName 'outlier.pdf'];
        print(fig, figFileName, '-dpdf', '-r600')
        figFileName =[fileName 'outlier.png'];
        print(fig, figFileName, '-dpng', '-r600')
        figFileName = [fileName 'outlier.fig'];
        savefig(fig, figFileName);
    end

end

yMaxs = zeros(size(sens, 2), 1);
yMins = zeros(size(sens, 2), 1);

for i = 1:size(sens, 2)
    yMins(i) = quantile(sens(:, i), 0.25);
    yMaxs(i) = quantile(sens(:, i), 0.75);
end

yMin = min(yMins);
yMax = max(yMaxs);
fig = figure;
handler = boxplot1(sens, params, 'whisker', 0);%, 'symbol', [0.1 0.2 1 '+']);
view(90, 90)

set(handler, 'linewidth', 2);
h = findobj(gca, 'tag', 'Outliers');
delete(h);
%axis square;
ylim([yMin - 1 yMax + 1]);

ax = gca; % current axes
ax.FontSize = 12;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
title({tit, ''}, 'FontSize', 16);
ax.YLabel.String = 'Percentage Sensitivity';

if save
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileName '.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileName '.png'];
    print(fig, figFileName, '-dpng', '-r600')
    figFileName = [fileName '.fig'];
    savefig(fig, figFileName);
end

end


