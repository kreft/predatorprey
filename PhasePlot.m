function PhasePlot(species, xLabelText, yLabelText, save)

% Creates a phase plot of column 2 vs column 3 of species

% function PhasePlot(species, xLabelText, yLabelText, save)
%
% species       - The sepcies to be plotted
% xLabelText    - The label for the x-axis
% yLabelText    - The label for the y-axis
% save			- Should the plot be saved

% Version    Author       Date     Affiliation
% 1.00       J K Summers  12/5/16  Kreft Lab - School of Biosciences -
%                                  University of Birmingham
%

plot (species(:, 2), species(:, 3), 'LineWidth', 4)
hold on
plot (species(1, 2), species(1, 3), 'o')
hold off
xlabel(xLabelText);
ylabel(yLabelText);

ax = gca; % current axes
ax.FontSize = 28;
ax.LineWidth = 1.2;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];

xl = xlim;
xlim([0, xl(2)]);

yl = ylim;
ylim([0, yl(2)]);

hold off

if save
    % Save the figure 
    fig.PaperUnits = 'centimeter';
    fig.PaperPosition = [2 2 17 17];
    fig.PaperPositionMode = 'manual';
    figFileName =[fileName '_PhasePlot.pdf'];
    print(fig, figFileName, '-dpdf', '-r600')
    figFileName =[fileName '_PhasePlot.png'];
    print(fig, figFileName, '-dpng', '-r600')
    figFileName =[fileName '_PhasePlot.fig'];
    print(fig, figFileName)
end

end
