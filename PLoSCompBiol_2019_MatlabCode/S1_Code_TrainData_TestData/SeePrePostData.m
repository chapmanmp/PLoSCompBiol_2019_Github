%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: June 9, 2017

%PURPOSE: See distribution of post-optimization vs pre-optimization data
%INPUT: 
    % M = pre-optimization
    % X = post-optimization   
    % N_W = # of wells in M ( = # wells in X )
    % AGENT_a = agent a name
    % STATE{i} = state i name
%OUTPUT: points
%NOTE: Forms of X & M = [ x[1, 1] ... x[1, 15], ..., x[7, 1] ... x[7, 15] ]
     % x[k, w] = cell counts, time k, well w
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SeePrePostData( M, X, N_W, AGENT_a, STATE )

[ n, m ] = size( M );  % n = # states, m = # samples

N_TIME = m / N_W;

figure; FigureSettings;

for i = 1 : n
    
    for k = 1 : N_TIME
        
       cols_k = (k-1)*N_W + 1 : k*N_W;
       
       subplot( n, N_TIME, (i-1)*N_TIME + k );
       
       plot( 1 : N_W, M( i, cols_k ), '*r' ); hold on; % pre-optimization (plot skips over NaNs)
       
       plot( 1 : N_W, X( i, cols_k ), '^b' );          % post-optimization
       
       if i == 1, title( [ AGENT_a, ', ', num2str( (k-1)*12 ), 'h'] ); end
       
       if i == n, xlabel( 'well' ); end;
       
       if k == 1, ylabel( STATE{i} ); end   
       
       YMIN = min( [ M( i, cols_k ) X( i, cols_k ) ] ) - 5;
       YMAX = max( [ M( i, cols_k ) X( i, cols_k ) ] ) + 5;
       
       axis( [ 1 N_W YMIN YMAX ] );
                     
    end
    
end

legend( 'pre-optimization', 'post-optimization' );
       
    
    