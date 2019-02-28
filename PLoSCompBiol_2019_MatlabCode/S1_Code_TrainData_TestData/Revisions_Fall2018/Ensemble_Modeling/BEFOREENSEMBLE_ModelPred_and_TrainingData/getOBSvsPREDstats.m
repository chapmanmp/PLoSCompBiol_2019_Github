%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: To quantify the difference between two time-series data sets
% INPUT:
    % M = [ x[0h,1] ... x[0h,N_W], x[12h,1] ... x[12h,N_W], ..., x[T,1] ... x[T,N_W] ] (e.g., for 4-well data T = 60h)
        % Observation time-series, function of death option o*, agent a
    % MHAT = [ A*x[0h,1] ... A*x[0h,N_W], ..., A*x[T,1] ... A*x[T,N_W]
    %         = [  x[12h,1] ...  x[12h,N_W], ..., x[T+12h,1] ... x[T+12h,N_W] ]
        % Prediction time-series using A*, agent a
    % N_W = # wells
% OUTPUT: p-values to assess difference between observations and predictions time series
    % pvals{i}: p-value for agent a, state i
% Author: Margaret Chapman
% Date: November 1, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pvals = getOBSvsPREDstats( M, MHAT, N_W )

% # states          
n = size( M, 1 ); pvals = cell(n,1);

M = M( :, N_W+1:end );                    % analyze data from 12h to Th
    
MHAT = MHAT( :, 1:end-N_W );              % analyze data from 12h to Th

N_T = size( M, 2 ) / N_W;                 % # time points for anova analysis 
    
y = cell(n,1); g1 = cell(n,1); g2 = cell(n,1);
% for state i,
% y{i}  = column vector of values
% g1{i} = row vector of associated time points
% g2{i} = cell of labels (O for observation or P for prediction)
    
for i = 1 : n

    for k = 1 : N_T
        
        cols_k = (k-1)*N_W + 1 : k*N_W; % cols for samples(time k)
        
        obs_ki  = M( i, cols_k ); pred_ki = MHAT( i, cols_k );
        
        for w = 1 : N_W
            
            if ~isnan(obs_ki(w)),  y{i} = [y{i}; obs_ki(w)];  g1{i} = [ g1{i} k ]; g2{i} = [ g2{i}; {'O'} ]; end
                   
            if ~isnan(pred_ki(w)), y{i} = [y{i}; pred_ki(w)]; g1{i} = [ g1{i} k ]; g2{i} = [ g2{i}; {'P'} ]; end
    
        end
        
    end
        
    pvals{i} = anovan(y{i}, {g1{i}, g2{i}}, 'display', 'off'); %N-way analysis of variance (ANOVA)

    pvals{i} = pvals{i}(2); % extract p value corresponding to the factor g2{i} which has the levels O and P
                            % p value < 0.05 means that the observations and the predictions *are* significantly different
end
