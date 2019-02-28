%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: Nov. 7, 2017

% PURPOSE: Executes alternating minimization to optimize dynamics with (lambda, mu, gamma), specific agent

% Allow for extra constraints on model

% See notes for AlternateMinimums.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ A, X, iter ] = try_AlternateMinimums( M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m, epsilon, idx )

A_i = try_argmin_A_Xfix( GetWarmStart( M, Jav, N_W ), M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx );  % good initialization

iter = 1; MAXITER = 1000;

while( true )
    
    X_i     = argmin_X_Afix( A_i, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, m );               % optimize X, A is fixed

    A_iPLUS = try_argmin_A_Xfix( X_i, M, Jav, N_W, lambda, mu, f_p, f_d, f_m, n, idx );             % optimize A, X is fixed
            
    if ( norm(A_iPLUS - A_i, 'fro')/norm(A_i, 'fro')<epsilon || iter>=MAXITER )
        
        break;
        
    else
        
        A_i = A_iPLUS;
        
        iter = iter + 1;
        
    end
     
end

A = A_iPLUS;

X = X_i;





