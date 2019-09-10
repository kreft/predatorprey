function bdLeft = TestStat(dR, startBd, simTimes)
   
% Calculate the data from theta is within an acceptable error of obsData.
% 
% Run the simulation with the candidate theta and determine if this is
% within an acceptable error of the observed data
%
% function bdLeft = TestStat(dR, startBd, simTimes)
%
% toletable     - True if the data is within the error threshold, false
% otherwise.
%
% Version    Author       Date      Affiliation
% 1.00       J K Summers  28/08/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

    options = odeset('RelTol', 1e-1);
    [t, bdLeft] = ode45(@TestStatODE, simTimes, startBd, options, dR);

end