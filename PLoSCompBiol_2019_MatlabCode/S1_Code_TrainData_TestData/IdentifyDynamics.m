%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: June 13, 2017

% PURPOSE: Perform all model identification computations, agent a, even death, mu = lambda
% INPUT:
    % lambdas(c) = value of lambda, combination c
    % epsilon = stopping criterion, alternating minimization (AM)
    % EVEN_DEATH = death option index for even death
    % P_a{k}(i, w) = # phenotype i (live & dying), well w, time k, agent a
    % d_a{k}(w) = fraction dying, well w, time k, agent a
    % N_CV = # test wells
    % N_WELL = # wells in total
    % Xin = NaN if function is called for model id alone 
    % Xin = post-optimization data, even death, if function is called for bootstrap
 % OUTPUT:
    % (A_STAR, X_STAR) = optimized (dynamics, data), lambda*
    % lambda* = best choice found via cross-validation
    % iter* = # AM iterations for (A_STAR, X_STAR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ A_STAR, X_STAR, lambda_STAR, iter_STAR ] = IdentifyDynamics( lambdas, epsilon, EVEN_DEATH, P_a, d_a, N_CV, N_WELL, Xin )

% get train test data & wells
[ Train, Wtrain, Test_e, Test_l, Test, Wtest ] = GetTrainTestDW( EVEN_DEATH, P_a, d_a, N_CV, N_WELL, Xin ); 
   
% cross validate
[ lambda_STAR, errs ] = CrossValidate( Train, Test_e, Test_l, P_a, d_a, Wtrain, lambdas, epsilon, N_WELL-N_CV );

% set up AM( all wells )
[ Jav, n, m, f_p, f_d, f_m, idx ] = SetupAM( P_a, d_a, 1:N_WELL );

% pre-optimization data, all wells, even death
M = CombineTrainTestData( Train, Wtrain, Test, Wtest, N_WELL );

% dynamics & post-opt data identified on all wells, (lambda*, mu* = lambda*, EVEN DEATH)
[ A_STAR, X_STAR, iter_STAR ] = AlternateMinimums( M, Jav, N_WELL, lambda_STAR, lambda_STAR, f_p, f_d, f_m, n, m, epsilon, idx ); 
    
% diplay progress
disp( [ 'model id done, even death, mu = lambda, lambda* = ', num2str(lambda_STAR), '. AM iter = ', num2str(iter_STAR) ] );

        
        
 
    
    
    