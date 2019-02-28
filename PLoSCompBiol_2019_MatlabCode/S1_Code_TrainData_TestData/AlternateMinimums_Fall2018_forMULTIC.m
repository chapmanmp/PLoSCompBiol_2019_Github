%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: November 6, 2018

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
%OUTPUT: optimized dynamics & filled-in cell counts for specific (lambda,
%mu, gamma) & agent; # iterations; 
% noisy initial cell counts matrix used for sys id to examine effect of different initial conditions (fall 2018); 
% prior initial cell counts matrix used for sys id 2017 results
%NOTE: 
    %normalization factor for |P|_F is 1 / sqrt( # terms in P )
    %Good guess for A_i is obtained using a 'warm start' data matrix (NaNs filled with average of available)
    %Fall 2018 revision extracts the A matrix at each iteration, myAs{i} = A matrix at iteration i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ A, X, iter, myAs, X0_withNoise, X0_2017 ] = AlternateMinimums_Fall2018_forMULTIC( M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m, epsilon, idx )

X0_withNoise = GetWarmStart_MULTIC( M, Jav, N_W ); 
% X0 = initial cell counts matrix = missing samples at time k replaced with average of the available samples at time k + noise

A_i = argmin_A_Xfix( X0_withNoise, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx );  % good initialization

iter = 1; MAXITER = 1000; myAs = cell(MAXITER+1, 1);

while( true )
    myAs{iter} = A_i;
    X_i     = argmin_X_Afix( A_i, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m );               % optimize X, A is fixed

    A_iPLUS = argmin_A_Xfix( X_i, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx );             % optimize A, X is fixed
           
    if ( norm(A_iPLUS - A_i, 'fro')/norm(A_i, 'fro')<epsilon || iter>=MAXITER )
        myAs{iter+1} = A_iPLUS;
        break;
        
    else
        
        A_i = A_iPLUS;
        
        iter = iter + 1;
        
    end
     
end

A = A_iPLUS;

X = X_i;

myAs = myAs(1:iter+1); % remove entries corresponding to iterations that were not executed

X0_2017 = GetWarmStart( M, Jav, N_W ); % to use for comparison to X0_withNoise; was used for sys id 2017 results




