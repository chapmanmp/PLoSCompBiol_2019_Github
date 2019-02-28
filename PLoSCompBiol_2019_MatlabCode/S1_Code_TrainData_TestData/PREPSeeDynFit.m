%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 20, 2017

% PURPOSE: To sort test sample & prediction into data structures for later plotting.
% INPUT:
    % M{a} = [ x[0h,1] ... x[0h,N_W], ..., x[60h,1] ... x[60h,N_W] ]
        % 4-well data, function of death option o*, 'test sample'
    % MHAT{a} = [ x[12h,1] ... x[12h,N_W], ..., x[72h,1] ... x[72h,N_W] ]
        % prediction via A*(15-well), 'prediction'
    % N_W = # wells in 4-well data = 4
    % N_AGENT, n, N_T = # agents, # states, # time pts, resp.
% OUTPUT: 
    % ( tspl{a}{i}{1}(k), tspl{a}{i}{2}(k) ) = ( mean, std ), test sample, agent a, state i, time k
    %       F     ...         F              ...              test sample fraction     ...
    % ( pred{a}{i}{1}(k), pred{a}{i}{2}(k) ) = ( mean, std ), prediction, agent a, state i, time k
    %       F     ...         F              ...              prediction fraction      ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ tspl, pred, tsplF, predF, N_AGENT, n, N_T ] = PREPSeeDynFit( M, MHAT, N_W )

N_AGENT = length( M ); n = size( M{1}, 1 ); N_T = size( M{1}, 2 ) / N_W; 

tspl = cell( N_AGENT, n, 2 ); pred = tspl; tsplF = tspl; predF = tspl; 

for a = 1 : N_AGENT 
    %          0h                , 12h, ..., 60h             ; M & M_HAT share initial condition
    MHAT{a} = [ M{a}( :, 1:N_W ), MHAT{a}( :, 1:end-N_W ) ];
    
    for k = 1 : N_T
        
        cols_k = (k-1)*N_W + 1 : k*N_W; % cols for samples(time k)
        
        ts_k = sum( M{a}( :, cols_k ) ); tHATs_k = sum( MHAT{a}( :, cols_k ) ); % sum over cols_k
        
        for i = 1 : n
                                                                               
            xs_ki = M{a}( i, cols_k );   
            
            tspl{a}{i}{1}(k) = nanmean( xs_ki ); tsplF{a}{i}{1}(k) = nanmean( xs_ki./ts_k );
            
            tspl{a}{i}{2}(k) = nanstd(  xs_ki ); tsplF{a}{i}{2}(k) = nanstd(  xs_ki./ts_k );
            
            xHATs_ki = MHAT{a}( i, cols_k );
            
            pred{a}{i}{1}(k) = nanmean( xHATs_ki ); predF{a}{i}{1}(k) = nanmean( xHATs_ki./tHATs_k );
            
            pred{a}{i}{2}(k) = nanstd(  xHATs_ki ); predF{a}{i}{2}(k) = nanstd(  xHATs_ki./tHATs_k );
            % std, mean ignoring nans
        end
        
    end
    
end