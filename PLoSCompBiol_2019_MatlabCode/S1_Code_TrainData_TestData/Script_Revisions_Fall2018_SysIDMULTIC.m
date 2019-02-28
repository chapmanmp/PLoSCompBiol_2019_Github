%% Runs system id for multiple initial conditions

%% SET-UP
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
PARAM = {'\rho_1', '\rho_{12}', '\rho_{13}', '\rho_{14}', '\rho_{1D}', '\rho_{21}', '\rho_2', '\rho_{23}', '\rho_{24}', '\rho_{2D}',...
               '\rho_{31}', '\rho_{32}', '\rho_3', '\rho_{34}', '\rho_{3D}', '\rho_{41}', '\rho_{42}', '\rho_{43}', '\rho_4', '\rho_{4D}'};

% Based on CV STUDY, narrow down parameter choices to even death, mu = lambda, & several choices for lambda.
lambdas = [ 1; 1/2; 1/10; 1/20; 1/10^2; 1/200; 1/10^3 ];

N_IC = 10;                      % # different initial conditions to consider
A_STAR_MULTIC=cell(N_AGENT,1);  % A_STAR_MULTIC{a}{ic} = dynamics, agent a, initial condition X0_withNoise{a}{ic}
X0_withNoise=cell(N_AGENT,1);   % X0_withNoise{a}{ic} = (ic)th initial cell counts matrix, agent a
X0_2017=cell(N_AGENT,1);        % X0_2017{a} = initial cell counts matrix used for 2017 sys id results

%% System ID from multiple initial conditions (to manage problem of trapping in local minima)
for a = 1 : N_AGENT
    
    rng default;  % set random number generator to default for reproducibility
    
    % identify dynamics starting from different inital conditions
    [A_STAR_MULTIC{a}, ~, ~, X0_withNoise{a}, X0_2017{a}] = IdentifyDynamics_Fall2018_forMULTIC( lambdas, epsilon, EVEN_DEATH, P{a}, d{a}, N_CV, N_WELL, NaN, N_IC );
     
    disp([AGENT{a}, ' done']);
    
end

%% COMPARE initial condition trials to 2017 results

load('Results_Summer_2017\model_id\model_id_K14VIMK19_july31.mat');
A_STAR_2017 = A_STAR; % rename 2017 model id results for clarity

max_abs_diff_A = cell(N_AGENT,N_IC);  max_abs_diff_X0 = cell(N_AGENT,N_IC);
for a = 1 : N_AGENT
for ic = 1 : N_IC
    max_abs_diff_A{a}{ic} = max(max(abs(A_STAR_MULTIC{a}{ic} - A_STAR_2017{a})));
    max_abs_diff_X0{a}{ic} = max(max(abs(X0_withNoise{a}{ic} - X0_2017{a})));
end
end
    