function [initVals, thetaODE] = ...
    NottinghamPhageSetup(theta, fixedVals, dataVals, simMode)

% Setup initial values and parameters based on the simMode
% 
% function [initVals, thetaODE] = ...
%     NottinghamPhageSetup(theta, fixedVals, dataVals, simMode)
%
% initVals  - Initial species values for simulations.
% thetaODE  - ODE parameters for simulations.
%
% theta         - Parameters for the simulation
% fixedVals     - Values that are not varied
% dataVals		- Initial species numbers
% simMode       - Which version of the model to use

% Version    Author       Date      Affiliation
% 1.00       J K Summers  10/06/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
% 1.01		 J K Summers  24/11/17  Added mode 12 for interconversion of 
%									sensitive & persistor bacteria & mode
%									13 to have conversion dependent on all
%									dead prey
% 1.02		 J K Summers  06/12/17  Added modes 22 & 26 to convert only
%									on prey killed by phage (22) &
%									by bdellovibrio (26)
% 1.03		 J K Summers  06/12/17  Added modes 14 & 15
% 1.04       J K Summers  11/12/17  Added mode 16
% 1.05		 J K Summers  12/12/17  Added modes 17 & 18
% 1.06       J K Summers  13/12/17  Added modes 19, 20 & 21
% 1.07       J K Summers  14/12/17  Added mode 23
% 1.08		 J K Summers  14/12/17  Added mode 25
% 1.09		 J K Summers  15/12/17  Added mode 27
% 1.10       J K Summers  03/09/18  Added modes 31 & 32
% 1.11       J K Summers  17/09/18  Added mode 33
% 2.0		 J K Summers  04/01/18  Amended for multiple initial species 
%                                   numbers & phage mutation rate

% simMode 1
% Full model

% simMode 2 
% Simplified model

% simMode 3 
% Mixed model

% simMode 6
% As mode 5, but Bdellovibrio now has a Holling type I functional response

% simModes 8, 16, 17 and 18
% As mode 7, but Halophage now has a Holling type I functional response

% simMode 9
% Single prey species - Bd Holling II, phage Holling I

% simMode 10
% As mode 8, but only two prey species

% simModes 11 and 19
% As mode 8, but Bdellovibrio also now has a Holling type I functional 
% response

% simMode 12
% As mode 11, but interconversion between sensitive & persister bacteria, 
% persisters grow into new persisters and have a maxGrowth that is a 
% multipler of the sensitive prey max growth rate

% simModes 23, 24, 25 and 28
% As mode 22, but bdellovibrio is Holling II

% simMode 27
% As mode 16, but allow mortality to vary

% simMode 31
% As mode 27, but resistance can also develop over time

% simMode 32
% As mode 27, but resistance not initially present, but develops over time

% simMode 33
% As mode 27, but phage burst size is fixed

initVals(1) = 0; 			% Initial substrate
initVals(2) = dataVals(1); 	% Sensitive bacteria - prey only

if simMode == 1
    initVals(1) = theta(1); % Substrate
    initVals(2) = theta(2); % Sensitive prey
    initVals(3) = theta(3); % Bdellovibrio persistent prey
    initVals(4) = theta(4); % Phage resistant prey
    initVals(5) = theta(5); % Resistant prey
    initVals(6) = theta(6); % Bdellovibrio
    initVals(7) = 0;        % Bdelloplasts
    initVals(8) = theta(7); % Phage
    initVals(9) = 0;        % Infected cells
elseif (simMode == 2 || simMode == 3)
    initVals(3) = theta(1); % Phage resistant bacteria
    initVals(4) = dataVals(2); % Bdellovibrio 
    initVals(5) = 0; % Bdelloplast
    initVals(6) = dataVals(3); % Bacteriophage
    initVals(7) = 0;
elseif simMode == 9
	initVals(3) = dataVals(2);	% Prey in Bd predation scenario
	initVals(4) = dataVals(3);	% Prey in Halophage predation scenario
	initVals(5) = dataVals(4); 	% Prey in dual predation scenario
    initVals(6) = dataVals(5); 	% Bdellovibrio in Bd predation scenario
    initVals(7) = dataVals(6);	% Bdellovibrio in Dual predation scenario
    initVals(8) = 0;           	% Bdelloplasts
    initVals(9) = dataVals(7); 	% Bacteriophage in Halophage predation scenario
    initVals(10) = dataVals(8);	% Bacteriophage in dual predation scenario
    initVals(11) = 0;           % infected cells
elseif simMode == 10
    initVals(3) = dataVals(1) * theta(1); 	% Phage resistant bacteria for prey only
    initVals(4) = dataVals(2);			  	% Sensitive prey - Bd predation
    initVals(5) = dataVals(2) * theta(1); 	% Phage resistant bacteria - Bd predation
    initVals(6) = dataVals(3);			  	% Sensitive prey - Bd predation
    initVals(7) = dataVals(3) * theta(1);	% Phage resistant bacteria - phage predation
    initVals(8) = dataVals(4);			  	% Sensitive prey - Bd predation
    initVals(9) = dataVals(4) * theta(1); 	% Phage resistant bacteria - dual predation
    initVals(10) = dataVals(5); 		  	% Bdellovibrio - Bd predation
    initVals(11) = dataVals(6);			  	% Bdellovibrio - dual predatio
    initVals(12) = 0;            			% Bdelloplasts
    initVals(13) = dataVals(7); 			% Bacteriophage - phage predation
    initVals(14) = dataVals(8);				% Bacteriophage - dual predation
    initVals(15) = 0;            			% infected cells
else
    % Bdellovibrio phenotypic persistence
    
    if simMode == 4
    	initVals(3) = dataVals(1) * theta(1); % Bd persistent bacteria
	    initVals(4) = dataVals(1) * theta(2); % Phage resistant bacteria
    else
    	initVals(3) = 0;			% Bd persistent prey - Prey only
    	initVals(5) = dataVals(2);	% Sensitive prey - Bd predation
    	initVals(6) = 0;			% Bd persistent prey - Bd predation
    	initVals(8) = dataVals(3);	% Sensitive prey - Phage predation
    	initVals(9) = 0;			% Bd persistent prey - Phage predation
    	initVals(11) = dataVals(4);	% Sensitive prey - dual predation
    	initVals(12) = 0;			% Bd persistent prey - dual predation
    	
    	if (simMode == 32)
    		initVals(4) = 0; 		% Phage resistant bacteria - Prey only
    		initVals(7) = 0;		% Phage resistant prey - Bd predation
    		initVals(10) = 0;		% Phage resistant prey - Phage predation
    		initVals(13) = 0;		% Phage resistant prey - Dual predation
    	else
	    	initVals(4) = dataVals(1) * theta(1); 	% Phage resistant bacteria - Prey only
	    	initVals(7) = dataVals(2) * theta(1); 	% Phage resistant bacteria - Bd predation
	    	initVals(10) = dataVals(3) * theta(1);	% Phage resistant bacteria - Phage predation
	    	initVals(13) = dataVals(4) * theta(1); 	% Phage resistant bacteria - Dual predation
	    end
	    	
    end

    initVals(14) = dataVals(5);	% Bdellovibrio - Bd predation
    initVals(15) = dataVals(6);	% Bdellovibrio - Dual predation
    initVals(16) = 0;           % Bdelloplasts
    initVals(17) = dataVals(7); % Bacteriophage - Phage predation
    initVals(18) = dataVals(8); % Bacteriophage - Dual predation
    initVals(19) = 0;           % Infected cells
    
    if (simMode == 13 || simMode == 16 || simMode == 17 || ...
            simMode == 18 || simMode == 19 || simMode == 20 || ...
            simMode == 21 || simMode == 22 || simMode == 23 || ...
            simMode == 24 || simMode == 25 || simMode == 26 || ...
            simMode == 27 || simMode == 28 || simMode == 31 || ...
            simMode == 32 || simMode == 33)
        initVals(20) = 0;
    end

end

if simMode == 1
    thetaODE.muMaxPrey = theta(8);
    thetaODE.Ksn = theta(9);
    thetaODE.yieldNPerS = theta(10);
    thetaODE.muMaxPred1 = theta(11);
    thetaODE.Knp = theta(12);
    thetaODE.mortality = theta(13);
    thetaODE.kP = theta(14);
    thetaODE.yieldPPerB = theta(15);
    thetaODE.muMaxPred2 = theta(16);
    thetaODE.Knv = theta(17);
    thetaODE.kV = theta(18);
    thetaODE.yieldVPerI = theta(19);
elseif simMode == 9
    thetaODE.muMaxPrey = theta(1);
    thetaODE.Ksn = theta(2);
    thetaODE.yieldNPerS = theta(3);
    thetaODE.muMaxPred1 = theta(4);
    thetaODE.Knp = theta(5);
    thetaODE.yieldPPerB = fixedVals(1);
    thetaODE.mortality = fixedVals(2);
	thetaODE.kP = theta(6);
    thetaODE.muMaxPred2 = theta(7);
    thetaODE.kV = theta(8);
    thetaODE.yieldVPerI = theta(9);
    thetaODE.yieldSPerP = theta(10);
    thetaODE.yieldSPerV = theta(11);
else
    
    if simMode == 31
	    thetaODE.rateDevResistance = theta(2);
	elseif (simMode == 29 || simMode == 32)
	    thetaODE.rateDevResistance = theta(1);
    end
    
    if (simMode == 4 || simMode == 12 || simMode == 13 || ...
            simMode == 22 || simMode == 23 || simMode == 24 || ...
            simMode == 25 || simMode == 26 || simMode == 28 || ...
            simMode == 31)
		
        if (simMode == 4 || simMode == 31)
    		thetaODE.muMaxPrey = theta(3);
    	else
	    	thetaODE.muMaxPrey = theta(2);
    		thetaODE.persGrowth = theta(3);
        end
		
    	thetaODE.Ksn = theta(4);
    	thetaODE.yieldNPerS = theta(5);
	    thetaODE.muMaxPred1 = theta(6);
	    
	    if (simMode == 12 || simMode == 13 || simMode == 22 || ...
                simMode == 26)
     		thetaODE.yieldPPerB = fixedVals(1);
   			thetaODE.mortality = fixedVals(2);
    		thetaODE.kP = theta(7);
    		thetaODE.muMaxPred2 = theta(8);
		    thetaODE.kV = theta(9);
   			thetaODE.yieldVPerI = theta(10);
    		thetaODE.yieldSPerP = theta(11);
		    thetaODE.yieldSPerV = theta(12);
    		thetaODE.rateDevPersist = theta(13);
    		thetaODE.rateRevert = theta(14);
	    else
	    	thetaODE.Knp = theta(7);
	    	
            if simMode == 4
    			thetaODE.mortality = theta(8);
    			thetaODE.kP = theta(9);
    			thetaODE.yieldPPerB = theta(10);
     			thetaODE.muMaxPred2 = theta(11);
    			thetaODE.Knv = theta(12);
    			thetaODE.kV = theta(13);
    			thetaODE.yieldVPerI = theta(14);
    			thetaODE.yieldSPerP = theta(15);
			    thetaODE.yieldSPerV = theta(16);
   			else
			    thetaODE.yieldPPerB = fixedVals(1);
    			thetaODE.kP = theta(8);

                if simMode == 31
    			    thetaODE.mortality = theta(9);
				    thetaODE.muMaxPred2 = theta(10);
				    thetaODE.kV = theta(11);
    				thetaODE.yieldVPerI = theta(12);
    				thetaODE.yieldSPerP = theta(13);
    				thetaODE.yieldSPerV = theta(14);
    				thetaODE.rateDevPersist = theta(15);
    			else
	    		    thetaODE.mortality = fixedVals(2);
				    thetaODE.muMaxPred2 = theta(9);
				    thetaODE.kV = theta(10);
    				thetaODE.yieldVPerI = theta(11);
    				thetaODE.yieldSPerP = theta(12);
    				thetaODE.yieldSPerV = theta(13);
    				thetaODE.rateDevPersist = theta(14);
    				thetaODE.rateRevert = theta(15);
				    thetaODE.rateDevResistance = theta(16);
                end
                
            end
			
	    end
	    	
	else
	    thetaODE.muMaxPrey = theta(2);

        if (simMode == 2 || simMode == 6)
		    thetaODE.yieldNPerS = theta(3);
		    thetaODE.muMaxPred1 = theta(4);
		    
		    if simMode == 2
		    	thetaODE.mortality = theta(5);
    			thetaODE.kP = theta(6);
    			thetaODE.yieldPPerB = theta(7);
			    thetaODE.muMaxPred2 = theta(8);
    			thetaODE.kV = theta(9);
    			thetaODE.yieldVPerI = theta(10);
    			thetaODE.yieldSPerP = theta(11);
			    thetaODE.yieldSPerV = theta(12);
		    else
    			thetaODE.kP = theta(5);
    			thetaODE.yieldPPerB = theta(6);
    			thetaODE.muMaxPred2 = theta(7);
    			thetaODE.kV = theta(8);
			    thetaODE.yieldVPerI = theta(9);
    			thetaODE.yieldSPerP = theta(10);
    			thetaODE.yieldSPerV = theta(11);
			    thetaODE.rateDevPersist = theta(12);
		    end
		    
		else
    		thetaODE.Ksn = theta(3);
	    	thetaODE.yieldNPerS = theta(4);
		    thetaODE.muMaxPred1 = theta(5);
    		
            if (simMode == 11 || simMode == 15 || simMode == 19 || ...
                    simMode == 20)
    			thetaODE.yieldPPerB = fixedVals(1);
    			thetaODE.mortality = fixedVals(2);
    			thetaODE.kP = theta(6);
    			thetaODE.muMaxPred2 = theta(7);
    			
    			if (simMode == 15 || simMode == 20)
    				thetaODE.Knv = theta(8);
				    thetaODE.kV = theta(9);
    				thetaODE.yieldVPerI = theta(10);
    				thetaODE.yieldSPerP = theta(11);
    				thetaODE.yieldSPerV = theta(12);
    				thetaODE.rateDevPersist = theta(13);
	    			thetaODE.rateDevResistance = theta(14);
    			else
				    thetaODE.kV = theta(8);
 				   	thetaODE.yieldVPerI = theta(9);
				    thetaODE.yieldSPerP = theta(10);
				    thetaODE.yieldSPerV = theta(11);
    				thetaODE.rateDevPersist = theta(12);
	    			thetaODE.rateDevResistance = theta(13);
    			end

    		else
			    thetaODE.Knp = theta(6);
			    
			    if (simMode == 3 || simMode == 5)
    				thetaODE.mortality = theta(7);
    				thetaODE.kP = theta(8);
     				thetaODE.yieldPPerB = theta(9);
     				thetaODE.muMaxPred2 = theta(10);
        			thetaODE.muMaxPred2 = theta(10);
   					thetaODE.Knv = theta(11);
    				thetaODE.kV = theta(12);
    				thetaODE.yieldVPerI = theta(13);
    				thetaODE.yieldSPerP = theta(14);
    				thetaODE.yieldSPerV = theta(15);
    				
    				if simMode == 5
    				    thetaODE.rateDevPersist = theta(16);
    				end

  				elseif (simMode == 27 || simMode == 29 || simMode == 30 ...
                        || simMode == 32 || simMode == 33)
    				thetaODE.kP = theta(7);
    				thetaODE.yieldPPerB = fixedVals(1);
    			    thetaODE.mortality = theta(8);
				    thetaODE.muMaxPred2 = theta(9);
				    thetaODE.kV = theta(10);
				    
				    if simMode == 33
					    thetaODE.yieldVPerI = fixedVals(3);
    					thetaODE.yieldSPerP = theta(11);
    					thetaODE.yieldSPerV = theta(12);
    					thetaODE.rateDevPersist = theta(13);
				    else
					    thetaODE.yieldVPerI = theta(11);
    					thetaODE.yieldSPerP = theta(12);
    					thetaODE.yieldSPerV = theta(13);
					    thetaODE.rateDevPersist = theta(14);
	    				thetaODE.rateDevResistance = theta(15);
    				end
    				
				else
			    	thetaODE.mortality = fixedVals(2);
			        thetaODE.kP = theta(7);
			        thetaODE.yieldPPerB = fixedVals(1);
        			thetaODE.muMaxPred2 = theta(8);
        			
        			if (simMode == 7 || simMode == 14 || simMode == 21)
        				thetaODE.Knv = theta(9);
        				thetaODE.kV = theta(10);
				        thetaODE.yieldVPerI = theta(11);
				        thetaODE.yieldSPerP = theta(12);
				        thetaODE.yieldSPerV = theta(13);
        				thetaODE.rateDevPersist = theta(14);
	    				thetaODE.rateDevResistance = theta(15);
        			else
					    thetaODE.kV = theta(9);
					    thetaODE.yieldVPerI = theta(10);
					    thetaODE.yieldSPerP = theta(11);
					    thetaODE.yieldSPerV = theta(12);
					    
                        if simMode == 10
					    	thetaODE.rateDevResistance = theta(13);
					    else
					        thetaODE.rateDevPersist = theta(13);
	    					thetaODE.rateDevResistance = theta(14);
                        end
						
        			end
        			
    			end
    			
            end
    	
        end
    	
    end
    
end
    
thetaODE.yieldBPerN = 1;
thetaODE.yieldBPerP = 1;
thetaODE.yieldIPerN = 1;
thetaODE.yieldIPerV = 1;

end