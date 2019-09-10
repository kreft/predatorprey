function likely = compareData(eData, oData, dataNoise, compMode)
   
% Compare the expected and observed data using the method requested.
% 
% function likely = compareData(eData, oData, dataNoise, compMode)
%
% likely        - The difference between the data using the method 
%                 requested.
%
% eData         - Expected data
% oData         - Observed data
% sigmaData     - How noisy do we believe the data to be?
% compMode      - Which comparison type should we use

% Version    Author       Date      Affiliation
% 1.00       J K Summers  12/06/17  Kreft Lab - School of Biosciences -
%                                   University of Birmingham
%

if compMode == 1
    likely = 0;
    
    for i = 1:size(oData)
        
        if oData(i) ~= eData(i)
            likely = likely -0.5 * abs(log(oData(i)) - log(eData(i))) / ...
                dataNoise^2;
        end
        
    end
    
elseif (compMode == 2) || (compMode == 3)
    likely = 0;
    
    for i = 1:size(oData)
        
        if oData(i) ~= eData(i)
            likely = likely + abs(log(oData(i)) - log(eData(i)));
        end
        
    end
    
elseif (compMode == 4)
    likely = 0;
    
    for i = 1:size(oData)
        
        if oData(i) ~= eData(i)
            likely = likely + (log(oData(i)) - log(eData(i)))^2;
        end
        
    end
    
    likely = likely ^ 0.5;
end

end