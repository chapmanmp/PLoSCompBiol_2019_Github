%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Plots data samples over the time horizon
% INPUT:
    % Mai = row vector of # cells state i, agent a
    % e.g., well 1, well 2, ..., well N_T ... well 1, well 2, ..., well N_W 
    %       |------------k=1------------|     |------------k=N_T----------|
    % N_W = # wells per time point in Mai (e.g., 4)
    % N_T = # time points in Mai (e.g., 6)
    % time_horizon = time horizon associated with Mai (e.g., [0 12 ... 60])
% OUTPUT: data points on existing figure
% Author: Margaret Chapman
% Date: November 10, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotDataSampENSEMBLE( Mai, N_W, N_T, time_horizon )

for w = 1 : N_W
    
    cols_w = w : N_W : N_W*N_T; % columns over the time horizon for well w
    
    plot( time_horizon, Mai(cols_w), '*k', 'linewidth', 1 ); hold on;
    
end