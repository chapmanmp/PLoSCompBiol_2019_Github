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
    % N_IC = # initial conditions to try
 % OUTPUT:
    % A_STAR{ic} = optimized dynamics matrix using lambda* & initial cell counts matrix X0_withNoise{ic}
    % lambda* = best choice found via cross-validation
    % iter*{ic} = # AM iterations to obtain A_STAR{ic}
    % X0_withNoise{ic} = noisy initial cell counts matrix (X0_2017 with added noise at columns where the samples were missing)
    % X0_2017 = initial cell counts matrix used for sys id 2017 (identical columns where the samples were missing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ A_STAR, lambda_STAR, iter_STAR, X0_withNoise, X0_2017 ] = IdentifyDynamics_Fall2018_forMULTIC( lambdas, epsilon, EVEN_DEATH, P_a, d_a, N_CV, N_WELL, Xin, N_IC )

% get train test data & wells
[ Train, Wtrain, Test_e, Test_l, Test, Wtest ] = GetTrainTestDW( EVEN_DEATH, P_a, d_a, N_CV, N_WELL, Xin ); 
   
% cross validate
[ lambda_STAR, errs ] = CrossValidate( Train, Test_e, Test_l, P_a, d_a, Wtrain, lambdas, epsilon, N_WELL-N_CV );

% set up AM( all wells )
[ Jav, n, m, f_p, f_d, f_m, idx ] = SetupAM( P_a, d_a, 1:N_WELL );

% pre-optimization data, all wells, even death
M = CombineTrainTestData( Train, Wtrain, Test, Wtest, N_WELL );

A_STAR = cell(N_IC,1); iter_STAR = cell(N_IC,1); X0_withNoise = cell(N_IC,1);
for ic = 1 : N_IC
    % dynamics & post-opt data identified on all wells, (lambda*, mu* = lambda*, EVEN DEATH)
    % different initial cell counts matrix at each iteration
    [ A_STAR{ic}, ~, iter_STAR{ic}, ~, X0_withNoise{ic}, X0_2017 ] = AlternateMinimums_Fall2018_forMULTIC( M, Jav, N_WELL, lambda_STAR, lambda_STAR, f_p, f_d, f_m, n, m, epsilon, idx ); 
    
    disp( [ 'model id done, even death, mu = lambda, lambda* = ', num2str(lambda_STAR), ...
            '. AM iter = ', num2str(iter_STAR{ic}), 'initial condition run ', num2str(ic) ] );
end

        
        
 
    
    
    