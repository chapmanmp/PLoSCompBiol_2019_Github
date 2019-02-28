%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Puts one-step predictions into a cell for further analysis
% INPUT:
    % Ma0 = data sample matrix for time 0, all states (NO nan's)
    %       well 1, well 2, ... , well N_W 
    %       |---------k=1=0h--------------|
    % N_W = # wells in data sample matrix 
    % M_HATa = one-step predictions via single model, all states (NO nan's)
    %       well 1, well 2, ... , well N_W ... well 1, well 2, ..., well N_W
    %       |---------k=2=12h-------------|...|---------k=N_TIME=72h--------|
    % N_TIME = # time points in predicted trajectory
    % N_STATE = # states
% OUTPUT:
    % predStatea{i}{k} = row vector of one-step predictions of #cells(state i, time k) via single model
    % N_W = # wells in data sample matrix 
    % B = # boostrap parameter sets
    % N_STATE = # states
% Author: Margaret Chapman
% Date: November 27, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function predStatea = getPredCellONEMODEL( Ma0, N_W, M_HATa, N_TIME, N_STATE )

predStatea = cell(N_STATE,N_TIME);

%          0h, 12h->72h
M_HATa = [ Ma0, M_HATa ];

for i = 1 : N_STATE
    
    for k = 1 : N_TIME
        
        M_HATaik = M_HATa(i, (k-1)*N_W + 1: k*N_W); % state i, wells 1->N_W, time k
        
        predStatea{i}{k} = M_HATaik;
        
    end
    
end

