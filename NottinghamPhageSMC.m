function NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
    tolerances, compMode, fitAll, savePlot, runNo)
 
% Run the SMC progress for a range of models.
% 
% Data and information on priors are read in from the data and protocol 
% files.
%
% function NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%    tolerances, compMode, fitAll, savePlot)
%
%
% protocolFiles - The parameters for the fitting process for the models
% dataFile      - Data to fit to
% particles     - The number of particles that should be found for each
%                 generation
% tolerances    - The various tolerances to try
% compMode      - How should simulated and observed data be compared?
% fitAll        - Should simulations be fitted to single predator only data
%                 or all data
% savePlot      - Should the plots be saved
 
% Version    Author       Date      Affiliation
% 1.00       J K Summers  28/11/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.01       J K Summers  05/12/17  Added diagnostics, % acceptance, plot
%                                   of data gaps and write accepted
%                                   parameters to a file. Also ensure
%                                   unique file names
% 2.00       J K Summers  14/12/17  Added ability to fit to only single
%                                   predator data
% 2.01		 J K Summers  05/10/18	Read in initial data values seperately 
%                                   from fixedVals
 
tic
warning('off');
numModels = size(protocolFiles, 2);
tolNums = size(tolerances, 2);

data = readtable(dataFile); 
simTimes = data.times;
obsData(:, 1) = data.EColiOnly;
obsData(:, 2) = data.EColiWithBd;
obsData(:, 3) = data.BdWithEColiOnly;
obsData(:, 4) = data.EColiWithPhage;
obsData(:, 5) = data.PhageWithEColiOnly;
obsData(:, 6) = data.EColiAll;
obsData(:, 7) = data.BdAll;
obsData(:, 8) = data.PhageAll;

baseTitle = [num2str(runNo) 'Models ' num2str(numModels) ...
    ' tolerances ' num2str(tolerances) ' I' num2str(particles) ' '];
 
for i = 1:numModels
    params = readtable(protocolFiles{i});
    numParams = params.numParams(1);
    
    models(i).numParams = numParams;
   
    % initial values
    models(i).paramNames = params.paramNames(1: numParams);

    models(i).initVals = log10(params.initVals(1: numParams));
    models(i).fixedVals = params.fixedVals;
    models(i).dataVals = params.dataVals;
 
    models(i).simMode = params.mode(1);
    models(i).dataNoise = params.dataNoise(1);
 
    models(i).sigmaMove = params.sigmaMove(1:numParams);
    models(i).minPrior = log10(params.minPrior);
    models(i).maxPrior = log10(params.maxPrior);
    
    modelName = ['Model ' num2str(models(i).simMode)];
    modelNames{i} = modelName;
end

for i = 1:tolNums
    j = 0;
    tries = 0;
    dataGaps = NaN(particles, 1);
    
    if ~fitAll
        dataGaps2 = NaN(particles, 1);
    end
   
    while j < particles
        tries = tries + 1;
        validParams = true;
        
        if i == 1
            model = randi(numModels);
            
            for k = 1:models(model).numParams
                candVals(k) = models(model).minPrior(k) + ...
                    rand * ...
                    (models(model).maxPrior(k) - ...
                    models(model).minPrior(k));
            end
                
        else
            testPart = randi(particles);
            model = foundParts(i - 1, testPart).numModel; 
            candVals = foundParts(i - 1, testPart).params;
        end
            
        % set each parameter
        for k = 1:models(model).numParams
    
            % propose a new value from a normal range
            candVals(k) = normrnd(candVals(k), models(model).sigmaMove(k));
 
            if (candVals(k) < models(model).minPrior(k)) || ...
                    (candVals(k) > models(model).maxPrior(k))
                validParams = false;
                break;
            end
        
        end
            
        if validParams
            paramVals = 10.^candVals;
 
            % evaluate if data from the candidate values gives data within
            % the acceptable error range from the observed data.
            [tolerable, dataGap, dataGap2, ~] = ...
                NottinghamPhageSimGrowth(paramVals, ...
                models(model).fixedVals, models(model).dataVals, ...
                simTimes, obsData, models(model).dataNoise, ...
                models(model).simMode, compMode, fitAll, tolerances(i));
 
            if tolerable
                % store the acceptable values
                j = j + 1;
                
                if fitAll
                    dataGaps(j) = dataGap2;
                else
                    dataGaps(j) = dataGap;
                    dataGaps2(j) = dataGap2;
                end
                
                if mod(j, 20) == 0
                    j
                end

            	foundParts(i, j).numModel = model;
                foundParts(i, j).params = candVals;
                
                if ~fitAll
                    foundParts(i, j).dataGap2 = dataGap2;
                end
                
            end
        
        end
        
    end

    acceptances = particles / tries * 100
    tolerances(i)
    plotGaps(dataGaps, savePlot, ...
        [baseTitle ' tolerance ' num2str(tolerances(i))]);

    if i ~= tolNums
        
        for j = 1:numModels
            modParts = 0;
            outputVals = models(j).paramNames';
            
            if ~fitAll
                outputVals = [outputVals 'Data Gap2'];
            end
    
            for k = 1:particles
        
                if foundParts(i, k).numModel == j
                    modParts = modParts + 1;
                    
                    if fitAll
                        outParams = zeros(1, models(j).numParams);
                    else
                        outParams = zeros(1, models(j).numParams + 1);
                    end
                    
                    for n = 1:models(j).numParams
                        outParams(n) = foundParts(i, k).params(n);
                    end
            
                    if ~fitAll
                        outParams(n + 1) = foundParts(i, k).dataGap2;
                    end
                   
                    outputVals = [outputVals; num2cell(outParams)];
                end
        
            end

            plotTitle = [baseTitle ' Tolerance' num2str(tolerances(i)) ...
                ' Model ' num2str(models(j).simMode) ' Params'];
            
            try
                xlwrite(plotTitle, outputVals);
            catch
                
                try
                    xlswrite(plotTitle, outputVals);
                catch
                end
                
            end
            
        end
        
    end

end

fitModel = zeros(particles, 1);
    
for j = 1:particles
    partModel = foundParts(tolNums, j).numModel;
    fitModel(j) = partModel;   
end

plotModels = categorical(fitModel, 1:numModels, modelNames, ...
    'Ordinal', true);
plotHistograms(plotModels, 0, numModels + 1, {'Model'}, ...
    false, savePlot, baseTitle);

for i = 1:numModels
    modParts = 0;
    histParams = [];
    outputVals = models(i).paramNames';

    if ~fitAll
    	outputVals = [outputVals 'Data Gap2'];
    end

    for j = 1:particles
        
        if foundParts(tolNums, j).numModel == i
            modParts = modParts + 1;
            
            for k = 1:models(i).numParams
                histParams(modParts, k) = foundParts(tolNums, j).params(k);
            end
            
            if ~fitAll
                histParams(modParts, k + 1) = ...
                    foundParts(tolNums, j).dataGap2;
            end
            
            outputVals = [outputVals; num2cell(histParams(modParts, :))];
        end
        
    end

    plotTitle = [baseTitle ' Model ' num2str(models(i).simMode) ...
        ' Params'];
    xlwrite(plotTitle, outputVals);

    if modParts > 0
        plotHistograms(histParams, models(i).minPrior, ...
            models(i).maxPrior, models(i).paramNames, true, savePlot, ...
            plotTitle);
    
        if modParts > 1
            plotGraphs(mean(10.^histParams), models(i).simMode, ...
                models(i).fixedVals, models(i).dataVals, simTimes, ...
                savePlot, plotTitle);
        else
            plotGraphs(10.^histParams, models(i).simMode, ...
                models(i).fixedVals, models(i).dataVals, simTimes, ...
                savePlot, plotTitle);
        end
        
        [paramCoeffs, scores] = pca(histParams);
        
        if fitAll
            
            try
                plotPCA(paramCoeffs, scores, models(i).paramNames, false, ...
                    '', 0, savePlot, [plotTitle ' PCA'])
            catch
            end
            
        else
%             plotPCA(paramCoeffs, scores, models(i).paramNames, true, ...
%                 dataGaps2, tolerances(size(tolerances, 2)), savePlot, ...
%                 [plotTitle ' PCA'])
        end
           
    end
    
end

toc
end

