%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 16, 2017

%PURPOSE: Compute 'warm' starting condition for data in alternating minimization
%INPUT:
    %M = [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ], cell count matrix
        % first entry of x is NaN \iff x is not available
    %Jav = col indices of M's available samples
    %N_W = # wells in M
%OUTPUT: Cell count matrix, same format as INPUT, missing samples at time k replaced with averaged available samples at time k
%NOTE: Assumes there is at least one available sample per time pt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = GetWarmStart( M, Jav, N_W )

m = size( M, 2 );                       % # samples

N_TIME = m / N_W;                       % # time points = # samples / # wells in M

Jna = setdiff( 1:m, Jav );              % col indices of M's not available samples

X = M;

for k = 1 : N_TIME
    
    J_k = (k-1)*N_W + 1 : k*N_W;                            % indices of samples(k)
    
    Jna_k = intersect( Jna, J_k );                          % indices of samples(not available, k)
    
    if ~isempty( Jna_k )                                    % if there is at least one sample(not available, k)
    
        Jav_k = intersect( Jav, J_k );                      % indices of samples(available, k)
    
        x_k = mean( M( :, Jav_k ), 2 );                     % average samples(available, k)
        
        X( :, Jna_k ) = repmat( x_k, size(Jna_k) );         % fill in samples(not available, k)
            
    end 
    
end
                
                
    
    
    
    