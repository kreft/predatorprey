function PhasePlot3(species, save, threeD, fileName)

% Creates a 2 or 3D phase plot
%
% function PhasePlot3(species, save, threeD, fileName)
%
% species   - The species values to plot
% save      - Should the plot be saved
% threeD    - Is a 3D or 2D plot required
% fileName  - Name by which to save plot

% Version    Author       Date     Affiliation
% 1.00       J K Summers  23/5/16  Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

fig = figure;

if threeD
    plot3(species(:, 1), species(:, 2), species(:, 3), 'LineWidth', 4)
else
    plot(species(:, 2), species(:, 3), 'LineWidth', 4)
end

hold on
axis square;

if threeD
    xlabel('Substrate (mg ml^{-1})', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Prey numbers (dry mass mg ml^{-1})', 'FontSize', 12, ...
        'FontWeight', 'bold');
    zlabel('Predator numbers (dry mass mg ml^{-1})', 'FontSize', 12, ...
        'FontWeight', 'bold');
    plot3(species(1, 1), species(1, 2), species(1, 3), 'o');
else
    xlabel('Prey numbers (dry mass mg ml^{-1})', 'FontSize', 12, ...
        'FontWeight', 'bold');
    ylabel('Predator numbers (dry mass mg ml^{-1})', 'FontSize', 12, ...
        'FontWeight', 'bold');
    plot(species(1, 2), species(1, 3), 'o');
end

ax = gca; % current axes
ax.FontSize = 28;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];

xl = xlim;
xlim([0, xl(2)]);

yl = ylim;
ylim([0, yl(2)]);

if threeD
    zl = zlim;
    zlim([0, zl(2)]);
end

hold off

if save
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileName '_PhasePlot3.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileName '_PhasePlot3.png'];
    print(fig, figFileName, '-dpng', '-r600')
    figFileName =[fileName '_PhasePlot3.fig'];
    print(fig, figFileName)
end

end

