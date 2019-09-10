function NottinghamPhagePlotSeries(graphSpecies, simTimes, ...
    splitPlots, cutPoint, distances, savePlot, baseFile)

% Plot the array of values for each species in each scenario.
% 
% Shows a range of species values that can arised from the accepted
% parameters
%
% function NottinghamPhagePlotSeries(graphSpecies, simTimes, ...
%     splitPlots, cutPoint, distances, savePlot, baseFile)
%
% graphSpecies  - Data to plot
% simTimes      - The times whose values are wanted
% splitPlot     - Should we split plots that match double data from those
% that do not?
% cutPoint      - distance above which data is not considered a good match
% distances     - distances to double predator data
% savePlot      - Should the plots be saved
% baseFile      - File Names for plots

% Version    Author       Date      Affiliation
% 1.00       J K Summers  10/10/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.02       J K Summers  27/10/17  Take species values to plot as a
% parameter

tic
scenarioTitles = {'Prey only', 'Prey + Bd', 'Prey + phage', 'All'}; 
speciesTitles = {'Substrate', 'Prey', 'Bdellovibrio', 'Halophage'};

for j = 1:4
    
    for i = 1:4
        curData = graphSpecies(:, :, j, i);
        
        if splitPlots
            plotTitle = ['Single ' scenarioTitles{j} ' ' speciesTitles{i}];
            fileName = [baseFile 'Single ' scenarioTitles{j} ' ' ...
                speciesTitles{i}];
        else
            plotTitle = [scenarioTitles{j} ' ' speciesTitles{i}];
            fileName = [baseFile ' ' scenarioTitles{j} ' ' ...
                speciesTitles{i}];
        end
            
        fig = figure;
    
        for k = 1:size(graphSpecies, 1)
            
            if splitPlots
                
                if distances(k) > cutPoint
                    plot(simTimes, curData(k, :));
                end
                
            else
                plot(simTimes, curData(k, :));
            end
            
            hold on
        end
    
        set(gca, 'YScale', 'log');
        axis square;

        ax = gca; % current axes
        ax.FontSize = 28;
        ax.LineWidth = 1.2;
        ax.TickDir = 'out';
        ax.TickLength = [0.02 0.02];
        xlim([simTimes(1) simTimes(size(simTimes, 1))])
        ylim([1, 1e11])
        title(plotTitle, 'FontSize', 12);

        xlabel('Time (hours)', 'FontSize', 12, 'FontWeight', 'bold');
        ylabel('Species per ml', 'FontSize', 12, 'FontWeight', 'bold');

        if savePlot
            % Save the figure 
            fig.PaperUnits = 'centimeter';
            fig.PaperPosition = [2 2 17 17];
            fig.PaperPositionMode = 'manual';
            figSaveName = [fileName '.pdf'];
            print(fig, figSaveName, '-dpdf', '-r600')
            figSaveName = [fileName '.fig'];
            savefig(fig, figSaveName)
            figSaveName = [fileName '.png'];
            print(fig, figSaveName, '-dpng', '-r600')
        end

    end

end

if splitPlots

    for j = 1:4
    
        for i = 1:4
            curData = graphSpecies(:, :, j, i);
            plotTitle = ['Double ' scenarioTitles{j} ' ' speciesTitles{i}];
            fileName = [baseFile 'Double ' scenarioTitles{j} ' ' ...
                speciesTitles{i}];
            fig = figure;

            for k = 1:size(plotSpecies, 1)

                if distances(k) < cutPoint
                    plot(simTimes, curData(k, :));
                end
                
                hold on
            end
    
            set(gca, 'YScale', 'log');
            axis square;

            ax = gca; % current axes
            ax.FontSize = 10;
            ax.LineWidth = 1.2;
            ax.TickDir = 'out';
            ax.TickLength = [0.02 0.02];
            xlim([simTimes(1) simTimes(size(simTimes, 2))])
            ylim([1, 1e11])
            title(plotTitle, 'FontSize', 12);

            xlabel('Time (hours)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel('Species per ml', 'FontSize', 12, 'FontWeight', 'bold');

            if savePlot
                % Save the figure 
                fig.PaperUnits = 'centimeter';
                fig.PaperPosition = [2 2 17 17];
                fig.PaperPositionMode = 'manual';
                figSaveName = [fileName '.pdf'];
                print(fig, figSaveName, '-dpdf', '-r600')
                figSaveName = [fileName '.fig'];
                savefig(fig, figSaveName
                figSaveName = [fileName '.png'];
                print(fig, figSaveName, '-dpng', '-r600')
            end
            
        end

    end

end

toc

end