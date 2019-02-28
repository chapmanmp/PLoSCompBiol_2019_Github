%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: COMPARE (2 phenotype)-SINGLE-MODEL ONE-STEP PREDICTION VERSUS TEST DATA (4-WELL)
% Author: Margaret Chapman
% Date: November 27, 2018
% Provides test samples as black stars, pink band marking the max/min
    % predictions from single 2-phenotype model, dotted line is median of predictions
% Provides p-values from two-way ANOVA specifying presence or lack of
%   significant disagreement between predictions and test samples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SET-UP

close all; clearvars; clc; 

load('Results_Summer_2017\test_dyn\K14only\test_dyn_K14only_aug6.mat'); % uses 'K14+ live' & 'K14- live'

STATE = {'K14^{hi} live', 'K14^{low} live', 'dying/dead'}; N_STATE = length(STATE); LIGHT_GRAY = [0.7 0.7 0.7];
LIGHT_PINK = [255/255 153/255 255/255];

time_horizon_samp = [0 12 24 36 48 60];    N_T = 6; % # time points in M{a}, in data sample horizon
time_horizon_pred = [0 12 24 36 48 60 72]; N_TIME = 7; % # time points in prediction horizon

% M{a} = 4-well data for testing, even death, ( 0h, ..., 60h ), agent a
    % N_W = # wells in Ma = 4
% M_HAT{a} = prediction using A*(15-well),    ( 12h, ..., 72h), agent a

pvals = cell(N_AGENT,1); % pvals{a}{i} = p value to compare observations and predictions, state i, agent a
                         % p value < 0.05 means that the observations and the predictions *are* significantly different

predState{a} = cell(N_AGENT,1); curveUP = cell(N_AGENT,1); curveMI = cell(N_AGENT,1); curveLO = cell(N_AGENT,1);
%% COMPARE (2 phenotype)-MODEL PREDICTION AND TEST DATA (4-WELL)
                                                   % 12h->60h
K0 = 2; % do p-value calculation over time horizon k=2,...,N_T (initial conditions for predictions & data samples are equal)

for a = 1 : N_AGENT
                                         % 0h               12h->72h
    predState{a} = getPredCellONEMODEL( M{a}(:,1:N_W), N_W, M_HAT{a}, N_TIME, N_STATE );
    % predState{a}{i}{k} = row vector of one-step predictions of #cells(state i, time k) using [M{a}(:,1:N_W), M_HAT{a}]
    % k = 1 is 0h, k = 2 is 12h, ..., k = 7 is 72h
    
    pvals{a} = getPredvsSampSTAT( predState{a}, M{a}, N_W, N_T, N_STATE, K0 );  
    % pvals{a}{i} = p-value, ONE-STEP predictions versus data samples (state i, agent a) over time k=K0=2 to N_T
    %               via 2-way analysis of variance (ANOVA)
    
    [curveUP{a}, curveMI{a}, curveLO{a}] = getPredULBandONEMODEL( predState{a}, N_TIME, N_STATE );
    % curveUP{a}{i}(k) = maximum of predState{a}{i}{k}
    % curveMI{a}{i}(k) = median of predState{a}{i}{k}
    % curveLO{a}{i}(k) = minimum of predState{a}{i}{k}
    
    disp( [AGENT{a},' done'] );
        
end
                                                                  % 4 wells
%for a = 1 : N_AGENT, pvals{a} = getOBSvsPREDstats( M{a}, M_HAT{a}, N_W );
%end % matches result from getPredvsSampSTAT

figure; FigureSettings;
for a = 1 : N_AGENT
    
    for i = 1 : N_STATE
        
        subplot(N_AGENT, N_STATE, (a-1)*N_STATE + i);
        
        % plot upper/lower prediction band: max, median, min at each time point
        plotBandENSEMBLE( curveUP{a}{i}, curveMI{a}{i}, curveLO{a}{i}, time_horizon_pred, LIGHT_PINK );
        
        % plot individual predictions (red stars)
        % for k = 2 : N_TIME, plot( time_horizon_pred(k)*ones(N_W,1), M_HAT{a}(i,(k-2)*N_W+1:(k-1)*N_W), '*r', 'linewidth', 1 ); hold on; end
        
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
      
        


