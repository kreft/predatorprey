function PlotNorm(t, species, twoPreds, save, fileName)

% Plot of species vs time with each species normalised to its max value
%
% function PlotNorm(t, species, twoPreds, save, fileName)
% 
% t         - time series data
% species   - species data
% twoPreds  - Is there data for two predators?
% save      - Whether to save the plot
% fileName  - The file to save the plot in

% Version    Author       Date     Affiliation
% 1.00       J K Summers  12/5/16  Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

fig = figure;
normSpecies = species;

for s = 1:size(species, 2)
    normSpecies(:, s) = species(:, s) / max(species(:, s)) * 100;
end

plot (t, normSpecies, 'LineWidth', 4)
hold on
axis square;

xlabel('Time (hours)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Normalised Species numbers', 'FontSize', 12, 'FontWeight', 'bold');

if twoPreds
    legend('Substrate', 'Prey', 'Predator 1', 'Predator 2', ...
        'Location', 'NorthEast');
    legend('Substrate', 'Prey', 'Predator', 'Location', 'NorthEast');
end

legend('boxoff');

ax = gca; % current axes
ax.FontSize = 28;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];

yl = ylim;
ylim([0, yl(2)]);

title('Variation in normalised species numbers over time', 'FontSize', 12);
xlabel('Time (hour)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel({'Normalised species numbers', 'mg ml^{-1}'}, 'FontSize', 12, ...
    'FontWeight', 'bold');

hold off

if save
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileName '_normalised.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileName '_normalised.png'];
    print(fig, figFileName, '-dpng', '-r600')
    figFileName =[fileName '_normalised.fig'];
    savefig(fig, figFileName)
end

end

