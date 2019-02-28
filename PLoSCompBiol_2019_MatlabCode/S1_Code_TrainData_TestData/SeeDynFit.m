%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 21, 2017

% PURPOSE: To see how well dynamics identified on 15-well data fit to 4-well data
% INPUT:
    % M{a} = [ x[0h,1] ... x[0h,N_W], ..., x[60h,1] ... x[60h,N_W] ]
        % 4-well data, function of death option o*, 'test sample'
    % M_HAT{a} = [ x[12h,1] ... x[12h,N_W], ..., x[72h,1] ... x[72h,N_W] ]
        % prediction via A*(15-well), 'prediction'
    % N_W = # wells in 4-well data = 4
    % AGENT{a} = name agent a
    % STATE{i} = name state i 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SeeDynFit( M, M_HAT, N_W, AGENT, STATE )

[ tspl, pred, tsplF, predF, N_AGENT, n, N_T ] = PREPSeeDynFit( M, M_HAT, N_W );
 
TIME = 0: 12: (N_T-1)*12;

data_type{1} = 'cell count'; data_type{2} = 'cell fraction';

for a = 1 : N_AGENT
    
    figure; FigureSettings;
    
    for i = 1 : n
        
        %for j = 2 : 2
        for j = 1 : 1
    
            %subplot( n, 2, 2*(i-1) + j );
            subplot( 1, n, i ); 
        
            if j == 1, tspl_j = tspl{a}{i}; pred_j = pred{a}{i}; else, tspl_j = tsplF{a}{i}; pred_j = predF{a}{i}; end
        
            errorbar( TIME, tspl_j{1}, tspl_j{2},  'k', 'linewidth', 2 ); hold on;
            
            errorbar( TIME, pred_j{1}, pred_j{2}, ':r', 'linewidth', 2 );
            
            %if i == 1, title( [ AGENT{a}, ': ', data_type{j} ] ); end
            if i == 1, ylabel( [ AGENT{a}, ', ', data_type{j} ] ); end
            
            %if j == 1, ylabel( STATE{i} ); end; if i == n, xlabel( 'time (h)' ); end
            title( STATE{i} ); xlabel( 'time (h)' );
            
            if i == n, legend( 'data sample', 'prediction' ); end; xlim([min(TIME) max(TIME)]);
        
        end
        
    end
    
end