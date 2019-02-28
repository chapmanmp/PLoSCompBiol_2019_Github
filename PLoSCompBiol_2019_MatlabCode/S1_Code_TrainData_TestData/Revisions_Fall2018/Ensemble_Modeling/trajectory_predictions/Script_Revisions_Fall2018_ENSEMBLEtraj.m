%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Script to obtain ensemble model predictions using parameter sets from the boostrap
    % Ensemble model predictions versus data samples (either 15-well set or 4-well set)
    % Uses weighted least squares to optimize the initial condition for each bootstrapped model
    % so it's prediction can match the data samples as well as possible
% Author: Margaret Chapman
% Date: November 11, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SETUP
close all; clearvars; clc;

four_well_data = 0; % choose 1 to evaluate ensemble model predictions versus 4-well data set
                    % choose 0 to evaluate ensemble model predictions versus 15-well training data set

load('Results_Summer_2017\bootstrap\bootstrap_K14K19VIM_aug6.mat');
% B = total number of bootstrap iterations
% A_BOOT{a}{b} = optimized dynamics, agent a, bootstrap iteration b
time_horizon_pred = [0 12 24 36 48 60 72]; 

if four_well_data 
    load('Results_Summer_2017\test_dyn\K14VIMK19\test_dyn_K14VIMK19_july31.mat');
    %M{a} = 4-well data for testing, even death, ( 0h, ..., 60h ), agent a
    N_T = 6; % # time points in M{a}
    N_W = 4; % # wells in M{a}
    time_horizon_samp = time_horizon_pred(1:end-1);    
else
    N_W = N_WELL; % (= 15) # wells in M{a}
    M = cell(N_AGENT,1);
    for a = 1 : N_AGENT, M{a} = GetCellCtsMATRIX( GetCellCtsCELL( P{a}, d{a}, EVEN_DEATH, 1:N_W ), 1:N_W ); end
    % M{a} = 15-well data for training, even death ( 0h, ..., 72h ), agent a              % all 15 wells
    time_horizon_samp = time_horizon_pred;
    N_T = N_TIME; % # time points in M{a}
end
    
clearvars -except A_BOOT B N_TIME M N_W N_T N_AGENT AGENT time_horizon_pred time_horizon_samp
                                           
STATE = {'K14^{hi} live', {'VIM^{hi}K14^{low} live'}, {'K19^{hi}VIM^{low}K14^{low} live'}, {'K19^{low}VIM^{low}K14^{low} live'}, 'dying/dead'};
                                    
N_STATE = length(STATE); LIGHT_GRAY = [0.7 0.7 0.7];

predState = cell(N_AGENT,1); curveUP = cell(N_AGENT,1); curveMI = cell(N_AGENT,1); curveLO = cell(N_AGENT,1);
pvals = cell(N_AGENT,1);

%% COMPUTE BOOTSTRAP TRAJECTORY PREDICTIONS & 95% CONFIDENCE BAND
K0 = 1; % do p-value calculation over time horizon k=1,...,N_T (initial conditions for predictions & data samples differ)
for a = 1 : N_AGENT
  
    predState{a} = getPredTrajENSEMBLE( A_BOOT{a}, N_TIME, M{a}, N_W, N_T, B, N_STATE );
    % predState{a}{i}{k}(b) = # cells, state i, time k predicted under boostrap dynamics model A_BOOT{a}{b}
    
    pvals{a} = getPredvsSampSTAT( predState{a}, M{a}, N_W, N_T, N_STATE, K0 );
    % pvals{a}{i} = p-value, TRAJ predictions versus data samples (state i, agent a) over time k=K0=1 to N_T
    %               via 2-way analysis of variance (ANOVA)
    
    [curveUP{a}, curveMI{a}, curveLO{a}] = getPredBandENSEMBLE( predState{a}, N_TIME, N_STATE );
    % curveUP{a}{i}(k) = upper bound of 95% confidence interval of predState{a}{i}{k}
    % curveMI{a}{i}(k) = median of predState{a}{i}{k}
    % curveLO{a}{i}(k) = lower bound of 95% confidence interval of predState{a}{i}{k}
    
    disp( [AGENT{a},' done'] );
    
end

%% SEE RESULTS

figure; FigureSettings;
for a = 1 : N_AGENT
for i = 1 : N_STATE
        
        subplot(N_AGENT, N_STATE, (a-1)*N_STATE + i);
        
        % plot band of ensemble predictions (95% confidence interval centered at median at each time point, light gray band)
        plotBandENSEMBLE( curveUP{a}{i}, curveMI{a}{i}, curveLO{a}{i}, time_horizon_pred, LIGHT_GRAY );
        
        % plot all individual bootstrap predictions (red stars)
        % for k = 1 : N_TIME, plot( time_horizon_pred(k)*ones(B,1), predState{a}{i}{k}, '*r', 'linewidth', 1 ); hold on; end
  
        % plot data samples (black stars)
        plotDataSampENSEMBLE( M{a}(i,:), N_W, N_T, time_horizon_samp ); 
  
        title(STATE{i}); xlabel('time (h)'); if i == 1, ylabel([AGENT{a}, ', # cells']); end; xlim([min(time_horizon_pred) max(time_horizon_pred)]);
    
end
end





