function levelTest(dataFile, particles, ...
    tolerances, compMode, fitAll, savePlot)

% tols = [0.6 0.5 0.4 0.35 0.32 0.3 0.28 0.26 0.24 0.23 0.22 0.21 0.2];
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 27.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tols, compMode, fitAll, savePlot)
% 
% toc
% 
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 27.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tols, compMode, false, savePlot)
% 
% toc
% 
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 16.xlsx'
% protocolFiles{2} = 'InitTestVals - Nottingham SMC Mode 27.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tolerances, compMode, fitAll, savePlot)
% 
% toc
% 
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 8.xlsx'
% protocolFiles{2} = 'InitTestVals - Nottingham SMC Mode 9.xlsx'
% protocolFiles{3} = 'InitTestVals - Nottingham SMC Mode 10.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tolerances, compMode, fitAll, savePlot)
% 
% toc
% 
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 8.xlsx'
% protocolFiles{2} = 'InitTestVals - Nottingham SMC Mode 23.xlsx'
% protocolFiles{3} = 'InitTestVals - Nottingham SMC Mode 25.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tolerances, compMode, fitAll, savePlot)
% 
% toc
% 
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 8.xlsx'
% protocolFiles{2} = 'InitTestVals - Nottingham SMC Mode 23.xlsx'
% protocolFiles{3} = 'InitTestVals - Nottingham SMC Mode 17.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tolerances, compMode, fitAll, savePlot)
% 
% toc
% 
% protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 16.xlsx'
% protocolFiles{2} = 'InitTestVals - Nottingham SMC Mode 17.xlsx'
% protocolFiles{3} = 'InitTestVals - Nottingham SMC Mode 18.xlsx'
% tic
% 
% NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
%     tolerances, compMode, fitAll, savePlot)
% 
% toc
% 
protocolFiles{1} = 'InitTestVals - Nottingham SMC Mode 16.xlsx'
protocolFiles{2} = 'InitTestVals - Nottingham SMC Mode 19.xlsx'
protocolFiles{3} = 'InitTestVals - Nottingham SMC Mode 20.xlsx'
protocolFiles{4} = 'InitTestVals - Nottingham SMC Mode 21.xlsx'
tic

NottinghamPhageSMC(protocolFiles, dataFile, particles, ...
    tolerances, compMode, fitAll, savePlot)

toc

end
