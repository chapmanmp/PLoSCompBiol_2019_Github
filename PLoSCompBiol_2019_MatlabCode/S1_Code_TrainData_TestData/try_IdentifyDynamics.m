%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: Nov. 7, 2017

% PURPOSE: Perform all model identification computations, agent a, even
% death, mu = lambda

% All for extra constraints on model 
% See notes for IdentifyDynamics.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ A_STAR, X_STAR, lambda_STAR, iter_STAR ] = try_IdentifyDynamics( lambdas, epsilon, EVEN_DEATH, P_a, d_a, N_CV, N_WELL, Xin )

% get train test data & wells
[ Train, Wtrain, Test_e, Test_l, Test, Wtest ] = GetTrainTestDW( EVEN_DEATH, P_a, d_a, N_CV, N_WELL, Xin ); 
   
% cross validate
[ lambda_STAR, errs ] = try_CrossValidate( Train, Test_e, Test_l, P_a, d_a, Wtrain, lambdas, epsilon, N_WELL-N_CV );

% set up AM( all wells )
[ Jav, n, m, f_p, f_d, f_m, idx ] = SetupAM( P_a, d_a, 1:N_WELL );

% pre-optimization data, all wells, even death
M = CombineTrainTestData( Train, Wtrain, Test, Wtest, N_WELL );

% dynamics & post-opt data identified on all wells, (lambda*, mu* = lambda*, EVEN DEATH)
[ A_STAR, X_STAR, iter_STAR ] = try_AlternateMinimums( M, Jav, N_WELL, lambda_STAR, lambda_STAR, f_p, f_d, f_m, n, m, epsilon, idx ); 
    
% diplay progress
disp( [ 'model id done, even death, mu = lambda, lambda* = ', num2str(lambda_STAR), '. AM iter = ', num2str(iter_STAR) ] );

        
        
 
    
    
    