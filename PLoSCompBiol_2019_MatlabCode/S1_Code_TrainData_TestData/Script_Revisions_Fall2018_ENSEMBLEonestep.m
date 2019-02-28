%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Script to obtain ensemble model predictions using parameter sets from the boostrap
    % Ensemble model predictions versus data samples (either 15-well training set or 4-well test set)
% Author: Margaret Chapman
% Date: November 16, 2018
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

%% COMPUTE ONE-STEP ENSEMBLE PREDICTIONS & 95% CONFIDENCE BAND

K0 = 2; % do p-value calculation over time horizon k=2,...,N_T (initial conditions for predictions & data samples are equal)

for a = 1 : N_AGENT
    
    predState{a} = getPredOneStepENSEMBLE( A_BOOT{a}, N_TIME, M{a}, N_W, B, N_STATE );
    % predState{a}{i}{k} = row vector of one-step predictions of # cells(state i, time k) via boostrapped models
    
    pvals{a} = getPredvsSampSTAT( predState{a}, M{a}, N_W, N_T, N_STATE, K0 );  
    % pvals{a}{i} = p-value, ONE-STEP predictions versus data samples (state i, agent a) over time k=K0=2 to N_T
    %               via 2-way analysis of variance (ANOVA)
    
    [curveUP{a}, curveMI{a}, curveLO{a}] = getPredBandENSEMBLE( predState{a}, N_TIME, N_STATE );
    % curveUP{a}{i}(k) = upper bound of 95% confidence interval of predState{a}{i}{k}
    % curveMI{a}{i}(k) = median of predState{a}{i}{k}
    % curveLO{a}{i}(k) = lower bound of 95% confidence interval of predState{a}{i}{k}
    
    disp( [AGENT{a},' done'] );
    
end

figure; FigureSettings;
for a = 1 : N_AGENT
    
    for i = 1 : N_STATE
        
        subplot(N_AGENT, N_STATE, (a-1)*N_STATE + i);
        
        % plot band of ensemble predictions (95% confidence interval centered at median at each time point, light gray band)
        plotBandENSEMBLE( curveUP{a}{i}, curveMI{a}{i}, curveLO{a}{i}, time_horizon_pred, LIGHT_GRAY );
        
        % plot all individual bootstrap predictions (red stars)
        % for k = 1 : N_TIME, plot( time_horizon_pred(k)*ones(size(predState{a}{i}{k})), predState{a}{i}{k}, '*r', 'linewidth', 1 ); hold on; end
        
        % plot data samples (black stars)
        plotDataSampENSEMBLE( M{a}(i,:), N_W, N_T, time_horizon_samp );
        
        myp = pvals{a}{i}; % p-value, agent a, state i
        
        if myp < 0.001, mypstr = 'p < 0.001';   % reporting convention
        elseif myp > 0.99, mypstr = 'p > 0.99'; % reporting convention
        else, mypstr = ['p = ', num2str( round(myp, 2, 'significant') )]; % rounded to 2 significant digits
        end
        
        % to put text in legend without marker (from MATLAB Answers(TM), Walter Roberson, 21 Apr 2018)
        dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
        legend(dummyh, mypstr, 'Location', 'best');
        legend boxoff % Hides the legend's axes (legend border and background)
        
        title(STATE{i}); xlabel('time (h)'); if i == 1, ylabel([AGENT{a}, ', # cells']); end; xlim([min(time_horizon_pred) max(time_horizon_pred)]);
          
    end
    
end



