function [t, predVals, timeOut] = NottinghamPhageSim(ODEFunction, ...
        simTimes, initSpecies, thetaODE)
   
    options = odeset('Events', @myEventFcn);
%     options = odeset('RelTol', 1e-1, 'AbsTol', 1e-1, 'Events', ...
%         @myEventFcn);
    startTime = tic;
    timeOut = false;
    [t, predVals, te, ye, ie] = ode45(ODEFunction, simTimes, ...
        initSpecies, options, thetaODE);
         
    if size(predVals, 1) < size(simTimes, 1)
        timeOut = true;
    end
 
    function [value, isterminal, direction] = myEventFcn(t, predVals, ...
            thetaODE)
 
        t_limit = 1; % set a time limit (in seconds)
        value = t_limit - toc(startTime);
        
        if value < 0
            timeOut = true;
        end
        
        isterminal = 1;
        direction = 0;
    end
 
end

