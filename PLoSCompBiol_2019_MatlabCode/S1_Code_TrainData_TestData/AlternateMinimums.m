%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 16, 2016

%PURPOSE: Executes alternating minimization to optimize dynamics with (lambda, mu, gamma), specific agent
%INPUT:
    % M = cell cts matrix for specified gamma & agent, from empirical observations
        %M = [ x[1,W(1)] ... x[1,W(end)], ..., x[7,W(1)] ... x[7,W(end)] ] counts
    % Jav = col indices of M's available samples
    % N_W = # wells in M
    % lambda, mu = regularization parameters
    % f_p, f_d, f_m = normalization factors
    % n = # states = ( # phenotypes live + # dying )
    % m = # samples = # cols of M
    % epsilon = stopping criterion
    % idx = logical array to locate non-diagonal entries of nxn matrix
%OUTPUT: optimized dynamics & filled-in cell counts for specific (lambda, mu, gamma) & agent; # iterations
%NOTE: 
    %normalization factor for |P|_F is 1 / sqrt( # terms in P )
    %Good guess for A_i is obtained using a 'warm start' data matrix (NaNs filled with average of available)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ A, X, iter ] = AlternateMinimums( M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m, epsilon, idx )

A_i = argmin_A_Xfix( GetWarmStart( M, Jav, N_W ), M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx );  % good initialization

iter = 1; MAXITER = 1000;

while( true )
    
    X_i     = argmin_X_Afix( A_i, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m );               % optimize X, A is fixed

    A_iPLUS = argmin_A_Xfix( X_i, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx );             % optimize A, X is fixed
            
    if ( norm(A_iPLUS - A_i, 'fro')/norm(A_i, 'fro')<epsilon || iter>=MAXITER )
        
        break;
        
    else
        
        A_i = A_iPLUS;
        
        iter = iter + 1;
        
    end
     
end

A = A_iPLUS;

X = X_i;





