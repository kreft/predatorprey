function Plot3Single(xData, yData, zData, save, fileName)

% Create a 3D plot of prey numbers vs dilution rate and reservoir substrate
%
% function Plot3Single(xData, yData, zData, save, fileName)
% 
% xData     - Data to plot on x-axis
% yData     - Data to plot on y-axis
% zData     - Data to plot on z-axis
% save      - Should this plot be saved
% fileName  - Name by which to save plot.

% Version    Author       Date     Affiliation
% 1.00       J K Summers  23/5/16  Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

fig = figure;

plotSurface = surface(xData, yData, zData, gradient(zData));
view(3)
set(plotSurface, 'EdgeColor', 'none');

hold on
axis square;

xlabel('Reservoir substrate (mg ml^{-1})', 'FontSize', 12, ...
    'FontWeight', 'bold');
ylabel('Dilution rate (hour^{-1})', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('Prey numbers (dry mass mg ml^{-1})', 'FontSize', 12, ...
    'FontWeight', 'bold');

ax = gca; % current axes
ax.FontSize = 28;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];

xl = xlim;
xlim([0, xl(2)]);

yl = ylim;
ylim([0, yl(2)]);

zl = zlim;
zlim([0, zl(2)]);

hold off

if save
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileName '_results3D.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileName '_results3D.png'];
    print(fig, figFileName, '-dpng', '-r600')
    figFileName =[fileName '_results3D.fig'];
    savefig(fig, figFileName)
end

end

