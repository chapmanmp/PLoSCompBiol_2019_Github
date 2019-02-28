%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Provides a 95% confidence band around the median of the trajectories produced by the boostrap models
% INPUT:
    % predStatea{i}{k} = vector of # cells, state i, time k, agent a
    % N_TIME = # time points
    % N_STATE = # states
% OUTPUT:
    % curveUPa{i}(k) = upper bound of 95% confidence interval of predStatea{i}{k} (vector of predicted cell counts, state i, time k) 
    % curveMIa{i}(k) = median of Z
    % curveLOa{i}(k) = lower bound of 95% confidence interval of Z
% NOTE: Allows for varying numbers of predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [curveUPa, curveMIa, curveLOa] = getPredBandENSEMBLE( predStatea, N_TIME, N_STATE )

curveUPa = cell(N_STATE, 1); curveMIa = cell(N_STATE, 1); curveLOa = cell(N_STATE, 1); 

f = 0.95; % 95% confidence intervals
                        
for i = 1 : N_STATE % for each state
    
    for k = 1 : N_TIME % for each time point
        
        sorted_ik = sort(predStatea{i}{k});         % sorted_ik(1) = lowest, sorted_ik(end) = highest 
        
        N = length(sorted_ik);                      % number of predictions, state i, time k
        
        NtoShaveEachEnd = floor(N*(1-f)/2);         % Round DOWN to nearest int. Remove LESS numbers from top and bottom.
                                                    % Produces larger interval -> more uncertainty
                                                    % same way that we broke the tie for the parameter confidence intervals
                                                    
        LOind = NtoShaveEachEnd+1;                  % if N = 120, LOind = 4
                                                    % if N = 1800, LOind = 46
        
        UPind = N-NtoShaveEachEnd;                  % if N = 120, UPind = 117; length(118:120)/120 = 0.0250
                                                    % if N = 1800, UPind = 1755; length(1756:1800)/1800 = 0.0250                                           
        
        curveMIa{i}(k) = median(sorted_ik);         % median at time k, state i, value of middle curve
        
        curveLOa{i}(k) = sorted_ik(LOind);          % lower bound of 95% confidence interval, time k, state i
        
        curveUPa{i}(k) = sorted_ik(UPind);          % upper bound of 95% confidence interval, time k, state i
 
    end
    
end

% Old implementation
%LOind = 4; UPind = 117; %  1 2 3 [4 ... 117] 118 119 120
                         % (120-6)/120 = 0.95 since we are discarding 6 samples
                         % length( predStatea{i}{k} ) = 120 = # bootstrap iterations
        
        

        