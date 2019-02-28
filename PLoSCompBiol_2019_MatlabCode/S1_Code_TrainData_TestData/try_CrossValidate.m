%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: Nov. 7, 2017

% PURPOSE: Get best reg parameter choice via cross validation, even death, mu = lambda

% Allow for extra constraints on model

% See notes for CrossValidate.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ lambda_STAR, errs ] = try_CrossValidate( Train, Test_e, Test_l, P_a, d_a, Wtrain, lambdas, epsilon, N_TRAIN )

[ Jav, n, m_train, f_p, f_d, f_m, idx ] = SetupAM( P_a, d_a, Wtrain ); 

m_test = size( Test_l, 2 );     % # cols for cv error computation

N_C = length( lambdas );        % N_C = # reg parameter choices

errs = zeros( N_C, 1 );         % errs(c) = cv error, choice c
                                
for c = 1 : N_C
    
    % choice c
    lambda = lambdas( c );
    
    % dynamics & filled-in data trained w/ choice c
    [ A, X, iter ] = try_AlternateMinimums( Train, Jav, N_TRAIN, lambda, lambda, f_p, f_d, f_m, n, m_train, epsilon, idx );
    
    % cross-validation error, choice c
    errs(c) = 1 / sqrt( n*m_test ) * norm( Test_l - A * Test_e, 'fro' );
    
    % display progress
    disp( ['cv : ', num2str(c), ' out of ', num2str(N_C), ' done. AM iter = ', num2str( iter )] );
             
end

[~, cSTAR] = min( errs ); % index of minimum error among all choices

lambda_STAR = lambdas( cSTAR );



    