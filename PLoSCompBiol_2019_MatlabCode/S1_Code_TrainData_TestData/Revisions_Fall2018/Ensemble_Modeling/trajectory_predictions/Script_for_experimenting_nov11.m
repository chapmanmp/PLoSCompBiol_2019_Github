%% ENSEMBLE MODEL PREDICTIONS VIA BOOTSTRAPPED PARAMETER SETS

close all; clearvars; clc;

load('Results_Summer_2017\bootstrap\bootstrap_K14K19VIM_aug6.mat');
% B = total number of bootstrap iterations
% A_BOOT{a}{b} = optimized dynamics, agent a, step b

load('Results_Summer_2017\test_dyn\K14VIMK19\test_dyn_K14VIMK19_july31.mat');
%M{a} = 4-well data for testing, even death, ( 0h, ..., 60h ), agent a
clearvars -except A_BOOT B N_TIME M N_W N_AGENT STATE AGENT

                                           N_T = N_TIME-1; %6
time_horizon_pred = [0 12 24 36 48 60 72]; time_horizon_samp = time_horizon_pred(1:end-1);
                        % # states               # standard deviations
figure(8); FigureSettings; N_STATE = length(STATE); N_STD = 1; 

predState = cell(N_AGENT,1); curveUP = cell(N_AGENT,1); curveMI = cell(N_AGENT,1); curveLO = cell(N_AGENT,1);
%for a = 1 : N_AGENT
  a = 2;  
    predState{a} = getPredTrajENSEMBLE( A_BOOT{a}, N_TIME, M{a}, N_W, B, N_STATE );
    
    [curveUP{a}, curveMI{a}, curveLO{a}] = getPredBandENSEMBLE( predState{a}, N_STD, N_TIME, N_STATE );
  i = 2;
  predState_ai = predState{a}{i};
  for k = 1 : N_TIME
      plot( time_horizon_pred(k)*ones(size(predState_ai{k})), predState_ai{k}, '*' ); hold on; 
  end
  %plot( time_horizon_pred, curveUP{a}{i}, 'k' ); hold on;
  %plot( time_horizon_pred, curveLO{a}{i}, 'k' );
  
  plotBandENSEMBLE( curveUP{a}{i}, curveMI{a}{i}, curveLO{a}{i}, time_horizon_pred );
  
  plotDataSampENSEMBLE( M{a}(i,:), N_W, N_T, time_horizon_samp ) 
  %plot( time_horizon_pred, curveMI{a}{i}, ':k' ); hold on;
  
  title(STATE{i}); xlabel('time (h)'); if i == 1, ylabel([AGENT{a}, ', cell quantity']); end;
  
  axis([0 60 200 1000]);
    
%end

%%

% trajectory prediction to 72h
pred_traj = cell(B, N_W); 
%pred_traj{b}{ic}(:,k) = predicted state at time k starting from initial condition M{a}(:,ic) time 0h, well ic
                          % using bootstrapped model A_BOOT{a}{b}
% k = 1   2         6   7 =  N_TIME                       
%    [0h, 12h, ..., 60h, 72h]
% will be plotted against test data samples at time 0h, 12h, ..., 60h
for b = 1 : B % for each bootstrapped model
    for ic = 1 : N_W % for each initial condition (N_W = 4 test wells)         
%        generate predicted trajectory starting from initial condition M{a}(:,ic) under bootstrapped model A_BOOT{a}{b}
         pred_traj{b}{ic}(:,1) = M{a}(:,ic); % initial condition, test data, agent a, time 0, well ic
         for k = 1 : N_TIME-1
             pred_traj{b}{ic}(:,k+1) = A_BOOT{a}{b} * pred_traj{b}{ic}(:,k);
         end
         plot( [time_horizon 72], pred_traj{b}{ic}(state_i,:) ); hold on;    
    end
end
% get mean and std for all b's ic's per time point
% plot mean over time & shade in-between curve1 = mean + 2*std, curve 2 = mean - 2*std
% plot each test data point on top
% compute a p-value predictions versus data (do later)
% Claire suggests trajectory predictions: My immediate thoughts are to use the longer trajectory predictions for comparison.

% plot each test data point
for w = 1 : N_W % for each well
    cols_w = w : N_W : N_W*N_T; % columns corresponding to well w over time horizon
    plot( time_horizon, M{a}(state_i,cols_w), '*k', 'linewidth', 2 ); hold on;
end
