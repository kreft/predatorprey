function PlotMain(t, species, preyOnly, twoPreds, bdelloplast, S0, ...
    save, fileName)

% Plot the results of a simualation
% 
% function PlotMain (t, species, preyOnly, twoPreds, bdelloplast, S0, ...
%    save, fileName)
%
% t             - time series data
% species       - species results
% preyOnly      - True when predator information should not be displayed
% twoPreds      - True when there is data for two predators to display
% bdelloplast   - True to display data on the bdelloplast stage
% S0            - Reservoir substrate concentration, used in the plot title
% save          - Should the plot be saved
% fileName      - Name to give the saved plot

% Version    Author       Date     Affiliation
% 1.00       J K Summers  23/5/16  Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

fig = figure;

plotSpecies = species;
% plotSpecies(:, 1) = plotSpecies(:, 1) * 1e9;

if preyOnly
    plot(t, plotSpecies(:, 1:2), 'LineWidth', 4)
else
    plot(t, plotSpecies, 'LineWidth', 4)
end

hold on
axis square;

xlabel('Time (hours)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Species numbers (mg ml^{-1})', 'FontSize', 12, 'FontWeight', ...
    'bold');

if twoPreds 
    
    if bdelloplast
        legend('Substrate', 'Prey', 'Predator 1', 'Predator 2', ...
            'Bdelloplast', 'Location', 'NorthEast');
    else
        legend('Substrate', 'Prey', 'Predator 1', 'Predator 2', ...
            'Location', 'NorthEast');
    end
    
elseif preyOnly
    legend('Substrate', 'Prey', 'Location', 'NorthEast');
elseif bdelloplast
    legend('Substrate', 'Prey', 'Predator', 'Bdelloplast', 'Location', ...
        'NorthEast');
else
    legend('Substrate', 'Prey', 'Predator', 'Location', 'NorthEast');
end

legend('boxoff');

ax = gca; % current axes
ax.FontSize = 12;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];

yl = ylim;
ylim([0, yl(2)]);

title({'Variation in species numbers over time', ...
    ['Substrate ', num2str(S0), ' mg ml^{-1}'], ''}, 'FontSize', 12);
xlabel('Time (hour)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel({'Species numbers', 'mg ml^{-1}'}, 'FontSize', 12, ...
    'FontWeight', 'bold');

hold off

if save
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileName '_resultsSpecies.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileName '_resultsSpecies.png'];
    print(fig, figFileName, '-dpng', '-r600')
    figFileName =[fileName '_resultsSpecies.fig'];
    savefig(fig, figFileName)
end

end

