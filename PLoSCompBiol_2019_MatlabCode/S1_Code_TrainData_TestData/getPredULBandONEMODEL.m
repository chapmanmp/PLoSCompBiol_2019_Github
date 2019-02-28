%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Provides a upper/lower band around the median of the given trajectories
% INPUT:
    % predStatea{i}{k} = vector of # cells, state i, time k, agent a
    % N_TIME = # time points
    % N_STATE = # states
% OUTPUT:
    % curveUPa{i}(k) = maximum of predStatea{i}{k} (vector of predicted cell counts, state i, time k) 
    % curveMIa{i}(k) = median of predStatea{i}{k}
    % curveLOa{i}(k) = minimum of predStatea{i}{k}
% Author: Margaret Chapman
% Date: November 27, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [curveUPa, curveMIa, curveLOa] = getPredULBandONEMODEL( predStatea, N_TIME, N_STATE )
    
curveUPa = cell(N_STATE,1); curveMIa = cell(N_STATE,1); curveLOa = cell(N_STATE,1);

for i = 1 : N_STATE
    
    for k = 1 : N_TIME
        
        curveMIa{i}(k) = median( predStatea{i}{k} );
        
        curveLOa{i}(k) = min( predStatea{i}{k} );
        
        curveUPa{i}(k) = max( predStatea{i}{k} );
        
    end
    
end