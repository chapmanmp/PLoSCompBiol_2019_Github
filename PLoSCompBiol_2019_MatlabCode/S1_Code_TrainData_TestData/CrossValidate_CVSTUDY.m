%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Margaret P. Chapman
% Date: July 26, 2017

% PURPOSE: Get best training parameters via cross validation, for CV STUDY (all death options)
% INPUT:
    % Trains{o} = training data, death option o
    % Tests_e{o} = test data, earlier time pts, death option o
    % Tests_l{o} = test data, later time pts, death option o
    % P, d, Wtrain = used to get constants for AM( training data ); AM = alternating minimization
    % coms(c, :) = [ lambda value, mu value, death option ], combination c
    % epsilon = stopping criterion, AM
    % DO = # death options
    % N_TRAIN = # training wells
% OUTPUT:
    % c* s.t. coms(c*, :) = [ lambda* value, mu* value, death option* ], best combination, agent a
    % errs(c) = cross-validation error, combination c, agent a
    % iters(c) = # AM iterations, combination c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ cSTAR, errs, iters ] = CrossValidate_CVSTUDY( Trains, Tests_e, Tests_l, P, d, Wtrain, coms, epsilon, DO, N_TRAIN )

[ Jav, n, m_train, f_p, f_d, f_m, idx ] = SetupAM( P, d, Wtrain ); 

m_test = size( Tests_l{1}, 2 ); % # cols for cv error computation

N_COM = size( coms, 1 );        % N_COM = # (lambda, mu, death option) combinations

errs = zeros( N_COM, 1 );       % errs(c) = cv error, combination c

res_BYo = cell( DO, 1 );        % res_BYo{o}(i, :) = [ lambda, mu, error(lambda, mu, o) ], o's ith combination

iters = zeros( N_COM, 1 );      % iters(c) = # AM iterations, combination c
                                
for c = 1 : N_COM
    
    % (lambda, mu, death option) combination c
    lambda = coms( c, 1 ); mu = coms( c, 2 ); o = coms( c, 3 ); 
    
    % dynamics & filled-in data trained w/ combination c; Trains{o} : train data, function of death option o
    [ A, X, iters(c) ] = AlternateMinimums( Trains{o}, Jav, N_TRAIN, lambda, mu, f_p, f_d, f_m, n, m_train, epsilon, idx );

    % cross-validation error, combination c; Tests_e{o} & Tests_l{o}: test data earlier & later, functions of death option o
    errs(c) = 1 / sqrt( n*m_test ) * norm( Tests_l{o} - A * Tests_e{o}, 'fro' );
    
    % results by death option
    res_BYo{o}( ceil(c/DO), : ) = [ lambda, mu, errs(c) ];
    
    % display progress
    disp( ['cv : ', num2str(c), ' out of ', num2str(N_COM), ' done. AM iter = ', num2str( iters(c) )] );
             
end

[~, cSTAR] = min( errs ); % index of minimum error, all combinations
