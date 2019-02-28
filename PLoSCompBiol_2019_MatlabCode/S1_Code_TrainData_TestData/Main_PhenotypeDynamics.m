%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Margaret P. Chapman
%Date: May 11, 2017
%PURPOSE: Main script for phenotype dynamical model
%NOTE: 
    % + : hi, - : low
    % onlyK14 = 1 : phenotypes = { K14+, K14- }
    % onlyK14 = 0 : phenotypes = { K14+, VIM+/K14-, K19+/K14-/VIM-, K19-/K14-/VIM- }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0. SET-UP

close all; clearvars; clc;

FILE_NAME = 'Timeseries_Raw_15wells.xlsx';      
SHEET_NAME = 'Summary';                         % missing data marked with 'na' for 'not available'
COL_ROW_1 = 'E5';                               % 1st col-row
COL_ROW_L = 'K452';                             % last col-row
N_AGENT = 4;                                    % # agents
AGENT = {'DMSO', 'Tram.', 'BEZ', 'Comb.'};      % 1: DMSO, 2: Trametinib, 3: BEZ235, 4: Combination
N_TIME = 7;                                     % # time points (0 h, 12 h, ..., 72 h)
N_WELL = 15;                                    % # wells in total
DO = 3;                                         % # death options
N_CV = 5;                                       % # wells used to cross-validate (lambda, mu, death option)
epsilon = 10^(-6);                              % stopping criterion
EVEN_DEATH = 2;                                 % death option index for evenly distributed death among phenotypes
    
% Phenotype & death timeseries raw data for each agent
[ P, d ] = SortBySeries( SortRawData( FILE_NAME, SHEET_NAME, COL_ROW_1, COL_ROW_L, N_AGENT, N_TIME, N_WELL ) );

% Specify phenotype classes & dyn parameter names
onlyK14 = 0;                                                                
if onlyK14, STATE = {'K14^{hi} live', 'K14^{low} live', 'dying/dead'}; PARAM = {'\rho_1', '\rho_{12}', '\rho_{1D}', '\rho_{21}', '\rho_2', '\rho_{2D}'};
else 
    STATE = {'K14^{hi} live', {'VIM^{hi}K14^{low} live'}, {'K19^{hi}VIM^{low}K14^{low} live'}, {'K19^{low}VIM^{low}K14^{low} live'}, 'dying/dead'};
    PARAM = {'\rho_1', '\rho_{12}', '\rho_{13}', '\rho_{14}', '\rho_{1D}', '\rho_{21}', '\rho_2', '\rho_{23}', '\rho_{24}', '\rho_{2D}',...
               '\rho_{31}', '\rho_{32}', '\rho_3', '\rho_{34}', '\rho_{3D}', '\rho_{41}', '\rho_{42}', '\rho_{43}', '\rho_4', '\rho_{4D}'};
end

% Run test script
Test_SetUp( P, d );

%% 1. CROSS VALIDATION STUDY

% argmin_A_Xfix.m : Comment out 'A(n, 2:n-1) == A(n, 1)' b/c don't want equality constraints on death gains

lambdas = [ 1; 1/2; 1/10; 1/20; 1/10^2; 1/200; 1/10^3; 1/10^4; 1/10^5 ]; mus = lambdas;

coms_CV = GetCombinations_CVSTUDY( lambdas, mus, 1:DO ); % coms_CV(c, :) = [ lambda, mu, death option ], combination c 

errs_CV = cell( N_AGENT, 1 ); cSTAR_CV = cell( N_AGENT, 1 ); iters_CV = cell( N_AGENT, 1 );

for a = 1 : N_AGENT
        
    % format data based on phenotype class      
    if onlyK14, P_a = GetK14( P{a} ); else, P_a = P{a}; end
    
    % get train test data & wells
    [ Trains, Wtrain, Tests_e, Tests_l ] = GetTrainTestDW_CVSTUDY( DO, P_a, d{a}, N_CV, N_WELL );
   
    % cross validate
    [ cSTAR_CV{a}, errs_CV{a}, iters_CV{a} ] = CrossValidate_CVSTUDY( Trains, Tests_e, Tests_l, P_a, d{a}, Wtrain, coms_CV, epsilon, DO, N_WELL-N_CV );
    
    % see results
    SeeCV( cSTAR_CV{a}, errs_CV{a}, coms_CV, lambdas, mus, DO, AGENT{a} )
   
end

% return max # AM iterations over all cv steps & how often was it reached
[ max_AM_i_1, N_hit_1 ] = ProcessAMIter( iters_CV, N_AGENT, AGENT, size( coms_CV, 1 ) ); 
    
%% 2a. IDENTIFY DYNAMICS

% argmin_A_Xfix.m : 'A(n, 2:n-1) == A(n, 1)' enforces equality among death gains

% Based on CV STUDY, narrow down parameter choices to even death, mu = lambda, & several choices for lambda.
lambdas = [ 1; 1/2; 1/10; 1/20; 1/10^2; 1/200; 1/10^3 ];

A_STAR  = cell( N_AGENT, 1 );     % A_STAR{a} = dynamics, agent a
X_STAR      = cell( N_AGENT, 1 ); % X_STAR{a} = post-optimization data, agent a
lambda_STAR = cell( N_AGENT, 1 ); % lambda_STAR{a} = lambda that minimizes cv error, agent a
myAs = cell( N_AGENT, 1 );        % myAs{a} = cell that contains the value of A at each iteration of alternating minimums (Fall 2018 revision)
 
for a = 1 : N_AGENT
    
    % format raw phenotype timeseries
    if onlyK14, P_a = GetK14( P{a} ); else, P_a = P{a}; end
 
    % identify dynamics (Fall 2018 revision extracts A matrix at each iteration)
    %[ A_STAR{a}, X_STAR{a}, lambda_STAR{a}, ~ ] = IdentifyDynamics( lambdas, epsilon, EVEN_DEATH, P_a, d{a}, N_CV, N_WELL, NaN );
    [ A_STAR{a}, X_STAR{a}, lambda_STAR{a}, ~, myAs{a} ] = IdentifyDynamics_Fall2018( lambdas, epsilon, EVEN_DEATH, P_a, d{a}, N_CV, N_WELL, NaN );
    
    % display progress
    disp( [ AGENT{a}, ' model id done.' ] );
    
    % see evolution of parameters in A as AM algorithm proceeds (Fall 2018 revision)
    seeEvol_of_A_inAM( myAs{a}, PARAM, AGENT{a} );
    
end

%% 2b. TEST DYNAMICS ON 4-WELL DATA
    
% Phenotype & death timeseries 4-well raw data for each agent
N_W = 4; [ P4W, d4W ] = SortBySeries( SortRawData( 'Timeseries_Raw_4wells.xlsx', SHEET_NAME, COL_ROW_1, 'K124', N_AGENT, N_TIME-1, N_W ) );

M = cell( N_AGENT, 1 ); M_HAT = cell( N_AGENT, 1 );

for a = 1 : N_AGENT
    
    % format raw phenotype timeseries
    if onlyK14, P4W_a = GetK14( P4W{a} ); else, P4W_a = P4W{a}; end
    
    % 4-well data, even death
    M{a} = GetCellCtsMATRIX( GetCellCtsCELL( P4W_a, d4W{a}, EVEN_DEATH, 1:N_W ), 1:N_W ); % all 4 wells
    
    % prediction using A*(15-well), ( 12h, ..., 72h )
    M_HAT{a} = A_STAR{a} * M{a}; 
               
end

SeeDynFit( M, M_HAT, N_W, AGENT, STATE );  

%% 3. STATISTICAL ANALYSIS

B = 120;                            % # bootstrap steps
A_BOOT = cell( N_AGENT, B );        % A_BOOT{a}{b} = optimized dynamics, agent a, step b
iterB = cell( N_AGENT, 1 );         % iterB{a}(b) = # AM iterations model id, agent a, step b
paramB = cell( N_AGENT, 1 );        % paramB{a}( b, j ) = dyn param j, agent a, step b
ciBDs = cell( N_AGENT, 1 );         % ciBDs{a}( :, j ) = [ upper bound; lower bound ] 95% CI, dyn param j, agent a

for a = 1 : N_AGENT
    
    % format raw phenotype timeseries
    if onlyK14, P_a = GetK14( P{a} ); else, P_a = P{a}; end
 
    for b = 1 : B
        
        % identify dynamics on bootstrap set b
        [ A_BOOT{a}{b}, ~, ~, iterB{a}(b)] = IdentifyDynamics( lambdas, epsilon, EVEN_DEATH, P_a, d{a}, N_CV, N_WELL, X_STAR{a} );
         
        % arrange bootstrap model parameters
        paramB{a}( b, : ) = StackDynamicsParametersHorizonally( A_BOOT{a}{b} );
        
        % display progress
        disp( [ AGENT{a}, ' BOOT iter ', num2str(b), ' done out of ', num2str(B) ] );
    
    end
    
    ciBDs{a} = GetConfidenceIntervals( paramB{a} );
      
end

PlotConfidenceIntervals( ciBDs, AGENT, PARAM );

% display max # AM iterations over all bootstrap steps (cv steps *not* included) & how often it was reached
ProcessAMIter( iterB, N_AGENT, AGENT, B );

%% 


%Extract statistically significant differences between all condition pairs.
StatSigDiff_GSKvsControl = GetStatSigDiff(CIBounds_GSK, CIBounds_Control);
StatSigDiff_BEZvsControl = GetStatSigDiff(CIBounds_BEZ, CIBounds_Control);
StatSigDiff_COMBOvsControl = GetStatSigDiff(CIBounds_COMBO, CIBounds_Control);
StatSigDiff_GSKvsBEZ = GetStatSigDiff(CIBounds_GSK, CIBounds_BEZ);
StatSigDiff_GSKvsCOMBO = GetStatSigDiff(CIBounds_GSK, CIBounds_COMBO);
StatSigDiff_BEZvsCOMBO = GetStatSigDiff(CIBounds_BEZ, CIBounds_COMBO);















